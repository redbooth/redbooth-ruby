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
          collection_from attributes, response, session
        end

        private

        # Creates a collection object from the request and response params
        #
        # @param params [Hash] given request params
        # @param response [Redbooth::Request::Response] response object
        # @param session [Redbooth::Session] session Object
        # @return [Redbooth::Request::Collection]
        def collection_from(params, response, session)
          Redbooth::Request::Collection.new(response: response,
                                            resource: self,
                                            session: session,
                                            params: params,
                                            method: :index)
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
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
