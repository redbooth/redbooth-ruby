module RedboothRuby
  module ClientOperations
    module Metadata

      # Retrieves all available objects from the Redbooth API by searching by given
      # key and value into the metadata API
      #
      # @param [Hash] options Options to pass to the API
      # @return [Array] The available objects
      def metadata(attributes = {})
        response = RedboothRuby.request(:get, nil, 'metadata/search' , attributes, { session: session })
        collection_from attributes, response, session
      end

      private

      # Creates a collection object from the request and response params
      #
      # @param params [Hash] given request params
      # @param response [RedboothRuby::Request::Response] response object
      # @param session [RedboothRuby::Session] session Object
      # @return [RedboothRuby::Request::Collection]
      def collection_from(params, response, session)
        RedboothRuby::Request::Collection.new(response: response,
                                              resource: self,
                                              session:  session,
                                              params:   params,
                                              method:   :metadata)
      end
    end
  end
end
