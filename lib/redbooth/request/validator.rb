module Redbooth
  module Request
    class Validator
      attr_reader :info
      attr_accessor :response

      def initialize(info)
        @info = info
      end

      def validated_data_for(incoming_response)
        self.response = incoming_response
        verify_response_code
        info.data = JSON.parse(response.body) if response.status.to_i != 204
        info.data ||= {}
        validate_response_data
        info.data
      end

      protected

      def verify_response_code
        fail AuthenticationError if response.status.to_i == 401
        fail APIError if response.status.to_i >= 500
        fail NotFound if response.status.to_i >= 404
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
