module RedboothRuby
  class Client
    include RedboothRuby::ClientOperations::Search
    include RedboothRuby::ClientOperations::Metadata
    include Helpers

    RESOURCES = [ :me, :user, :task, :organization, :person, :project,
                  :conversation, :membership, :comment, :note, :subtask,
                  :file, :task_list ]

    attr_reader :session, :options

    # Creates an client object using the given Redbooth session.
    # existing account.
    #
    # @param session [Redbooth::Session] redbooth session object with the correct authorization
    # @param options [Hash] client options
    # @option options [Proc] retry (the client will handle) Retry block to be executed when client hits an async endpoint
    def initialize(session, options={})
      raise RedboothRuby::AuthenticationError unless session
      @session = session
      @options = options
      self
    end

    # Metaprograming of every resource to execute it over the perform!
    # method just to add session tho the resource
    #
    # @param [String||Symbol] action name of the action to execute over
    # @param [Hash] options for the execution
    # @return the execution return or nil
    #
    # @example
    #   session = RedboothRuby::Session.new(api_key: '_your_api_key_', auth_token: '_aut_token_for_the_user')
    #   client = RedboothRuby::Client.new(session)
    #   client.user.show # returns user profile
    #   client.files.all
    #
    RESOURCES.each do |resource|
      eval %{
        def #{resource.to_s}(action, options={})
          perform!(:#{resource.to_s}, action, options)
        end
      }
    end

    protected

    # Executes block with the access token
    #
    # @param [String||Symbol] resource_name name of the resource to execute over
    # @param [String||Symbol] action name of the action to execute over
    # @param [Hash] options for the execution
    # @return the execution return or nil
    def perform!(resource_name, action, options = {})
      ClientOperations::Perform.new(resource_name, action, session, options).perform!
    end
  end
end