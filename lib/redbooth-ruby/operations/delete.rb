module RedboothRuby
  module Operations
    module Delete
      module ClassMethods
        # Deletes the given object
        #
        # @param attributes [Hash] hash of given attributes passed to the delete method
        # @return [Boolean]
        def delete(attributes = {})
          id = attributes.delete(:id)
          response = RedboothRuby.request(:delete,
                                          nil,
                                          api_member_url(id, :delete),
                                          {},
                                          options_for_request(attributes)
                                         )
          true
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
