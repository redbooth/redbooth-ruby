module Redbooth
  module Operations
    module Index
      module ClassMethods
        # Retrieves all available objects from the Copy API
        #
        # @param [Hash] options Options to pass to the API
        # @return [Array] The available objects
        def index(attributes = {})
          session = attributes.delete(:session)
          response = Redbooth.request(:get, nil, api_collection_url , attributes, options_for_request(session: session))
          results_from response
        end

        # Returns the collection object build from the received response
        #
        # @param response [Array || Hash] parsed json response
        # @return [Redbooth::Collection]
        def results_from(response)
          results = []
          response.data.each do |obj|
            results << self.new(obj)
          end
          results
        end
        private :results_from
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
