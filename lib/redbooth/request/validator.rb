module Redbooth
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
      # return [Redbooth::Request::Response]
      def validated_response_for(incoming_response)
        self.raw_response = incoming_response
        verify_response_code
        response = Redbooth::Request::Response.new(headers: raw_response.headers,
                                                   body: raw_response.body,
                                                   status: raw_response.status.to_i)
        info.data = response.data
        validate_response_data
        response
      end

      protected

      def verify_response_code
        fail AuthenticationError if raw_response.status.to_i == 401
        fail APIError if raw_response.status.to_i >= 500
        fail NotFound if raw_response.status.to_i >= 404
      end

      def validate_response_data
        body ||= info.data
        if body.is_a?(Hash)
          if body['error']
            handle_api_error(body['error'], body['message'])
          elsif body['errors']
            body['errors'].each do |error|
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
