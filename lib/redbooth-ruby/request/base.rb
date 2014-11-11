module RedboothRuby
  module Request
    class Base
      attr_reader :info
      attr_accessor :response

      def initialize(info)
        @info = info
      end

      def perform
        fail RedboothRuby::AuthenticationError unless valid?
        connection.set_request_data
        send_request

        validator.validated_response_for(response)
      end

      def valid?
        return false unless info
        return false unless info.session
        return false unless info.session.valid?
        true
      end

      protected

      def send_request
        self.response = connection.request
      end

      def connection
        @connection ||= Connection.new(info)
      end

      def validator
        @validator ||= Validator.new(info)
      end
    end
  end
end
