module RedboothRuby
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

      # initializes the json data with the request body
      # or empty array if not
      def initialize_data
        @data = parse_body || {}
      end

      # Parses the json body if is a json valid string
      #
      def parse_body
        return unless body.is_a?(String)
        JSON.parse(body)
      rescue
        # not a valid json body
        nil
      end
    end
  end
end
