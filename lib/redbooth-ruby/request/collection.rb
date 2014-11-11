module RedboothRuby
  module Request
    class Collection
      attr_reader :response, :params, :method, :session, :resource

      def initialize(attributes={})
        @response = attributes[:response]
        @params = attributes[:params]
        @method = attributes[:method]
        @resource = attributes[:resource]
        @session = attributes[:session]
      end

      # Returns an array of resuce objects built from each one of the response items
      #
      # @return [Array(resource)]
      def all
        results = []
        response.data.each do |obj|
          results << resource.new(obj)
        end
        results
      end

      # Returns total pages
      #
      # @return [Integer]
      def total_pages
        return unless response.headers['PaginationTotalPages']
        response.headers['PaginationTotalPages'].to_i
      end

      # Returns elements per page
      #
      # @return [Integer]
      def per_page
        return unless response.headers['PaginationPerPage']
        response.headers['PaginationPerPage'].to_i
      end

      # Returns elements per page
      #
      # @return [Integer]
      def current_page
        return unless response.headers['PaginationCurrentPage']
        response.headers['PaginationCurrentPage'].to_i
      end

      # Return total elements
      #
      # @return [Integer]
      def count
        return all.size unless paginated?
        return all.size if total_pages.to_i <= 1
        total_pages * per_page
      end

      # Performs the request for the next page if exists
      #
      # @return [Redbooth::Request::Collection]
      def next_page
        return nil unless paginated?
        return nil unless (total_pages - current_page) > 0
        request_with(page: current_page + 1)
      end

      # Performs the request for the next page if exists
      #
      # @return [Redbooth::Request::Collection]
      def prev_page
        return nil unless paginated?
        return nil unless current_page > 1
        request_with(page: current_page - 1)
      end

      protected

      # Whenever the response is paginated or not
      def paginated?
        return false unless current_page
        true
      end

      # Dups the current collection overwriting the given attributes
      #
      # @return [Redbooth::Request::Collection]
      def dup_with(attributes={})
        dup_params = { response: response,
                       params: params,
                       method: method,
                       resource: resource,
                       session: session }.merge(attributes)
        self.class.new(dup_params)
      end

      # Repeats the request merged with the new params given
      #
      # @param new_params [Hash] params to overwrite or add in the new request
      # @return [Redbooth::Request::Collection]
      def request_with(new_params={})
        resource.send(method, params.merge(new_params).merge(session: session))
      end
    end
  end
end
