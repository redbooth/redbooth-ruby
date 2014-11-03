module Redbooth
  module Request
    class Collection
      attr_reader :response, :request_data

      def initialize(attributes={})
        @response = attributes[:response]
        @request_data = attributes[:request_data]
      end
    end
  end
end
