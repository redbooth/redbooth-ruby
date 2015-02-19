module RedboothRuby
  module ClientOperations
    class Perform
      include RedboothRuby::Helpers
      attr_accessor :resource_name, :action, :session, :options
      attr_accessor :tries, :processing_error, :oauth_token_expired_error

      def initialize(resource_name, action, session, options = {})
        @resource_name = resource_name
        @action = action
        @session = session
        @options = options
        @tries = 0
      end

      # Performs the resource action
      #
      # @return the execution return or nil
      def perform!
        @tries += 1
        fail RedboothRuby::AuthenticationError unless session
        resource(resource_name).send(action, options_with_session(options))
      rescue Processing => processing_error
        @processing_error = processing_error
        perform_processing!
      rescue OauthTokenExpired => oauth_token_expired_error
        @oauth_token_expired_error = oauth_token_expired_error
        perform_oauth_token_expired!
      end

      # Delays the execution of the enqueued processing
      #
      # @return the execution return or nil
      def perform_processing!
        delay = if processing_error && processing_error.response
          processing_error.response.data['retry_after'].to_i
        else
          10
        end
        retry_in(delay)
      end

      # Perform refresh on the session access token
      #
      # @return the execution return or raise OauthTokenExpired
      def perform_oauth_token_expired!
        if tries == 1 && refresh_session_access_token!
          perform!
        else
          raise oauth_token_expired_error
        end
      end

      private

      # Retries the request in the given time either calls the given
      # proc options[:retry] or executes it in this thread
      #
      def retry_in(delay)
        if options[:retry]
          options[:retry].call(delay)
        else
          sleep(delay)
          perform!
        end
      end

      # Merge the given options with the session for use the api
      #
      # @param [Hash] options options to merge with session
      # @return [Hash]
      def options_with_session(options={})
        options.merge(session: @session)
      end

      # Get the api resource model class by his name
      #
      # @param [String||Symbol] name name of the resource
      # @return [Copy::Base] resource to use the api
      def resource(name)
        Object.const_get("RedboothRuby::#{camelize(name)}") rescue nil
      end

      # Refresh the session access token if auto_refresh_token is enabled
      #
      # @return [Boolean]
      def refresh_session_access_token!
        session.auto_refresh_token && session.refresh_access_token!
      end

    end
  end
end