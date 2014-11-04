module Redbooth
  module Request
    # Wraps the API response parsing the json body and keeping interesting headers
    #
    class Response
      attr_accessor :body, :headers, :data, :status

      def initialize(attrs={})
        @body = attrs[:body]
        @headers = attrs[:headers]
        @status = attrs[:status]
        initialize_data
      end

      protected

      # Parses the json body and translates it to Ruby objects
      def initialize_data
        @data = case status
                when 204 then {}
                else
                  JSON.parse(body)
                end
      end
    end
  end
end
