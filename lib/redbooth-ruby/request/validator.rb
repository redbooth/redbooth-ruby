module RedboothRuby
  module Request
    class Validator
      attr_reader :info
      attr_accessor :raw_response, :response

      def initialize(info)
        @info = info
      end

      # Validates the given http response creating a response object or
      # failing with an error and description
      #
      # param incoming_response [] http response object
      # return [RedboothRuby::Request::Response]
      def validated_response_for(incoming_response)
        self.raw_response = incoming_response
        @response = RedboothRuby::Request::Response.new(headers: raw_response.headers,
                                                        body: raw_response.body,
                                                        status: raw_response.status.to_i)
        verify_response_code
        info.data = response.data
        validate_response_data
        response
      end

      protected

      # Verifies the response status code in case it fails with the dessired error
      # and message
      #
      def verify_response_code
        status = raw_response.status.to_i
        case
        when status == 401
          verify_authentication_header
          fail AuthenticationError
        when status >= 500
          fail APIError
        when status >= 404
          fail NotFound
        when [102, 202].include?(status)
          fail Processing, response
        end
      end

      # Checks the authetication header to ensure wich is the best error to throw
      #
      def verify_authentication_header
        case raw_response.headers['WWW-Authenticate']
        when /error\=\"invalid_token\".*expired/
          fail OauhtTokenExpired
        when /error\=\"invalid_token\".*revoked/
          fail OauhtTokenRevoked
        end
      end

      # Validates the body data returned in the response in case there is
      # an embed error it will fail with the dessired error and message
      #
      def validate_response_data
        if response.data.is_a?(Hash)
          if response.data['error']
            handle_api_error(response.data['error']['code'], response.data['error']['message'])
          elsif response.data['errors']
            response.data['errors'].each do |error|
              handle_api_error(error['code'], error['message'])
            end
          end
        end
      end

      def handle_api_error(code, message)
        error = case code
                when 1021, 1024  then ObjectNotFound.new(message)
                when 1300, 1303  then BadRequest.new(message)
                when 2000        then AuthenticationError.new(message)
                else
                  APIError.new(message)
                end
        fail error
      end
    end
  end
end
