module RedboothRuby
  module Operations
    module Create
      module ClassMethods
        # Creates a new object
        #
        # @param [Hash] attributes The attributes of the created object
        def create(attributes)
          session = attributes.delete(:session)
          response = RedboothRuby.request(:post,
                                          nil,
                                          api_collection_url(attributes),
                                          attributes,
                                          options_for_request(session: session)
                                         )
          new(response.data)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
