module RedboothRuby
  module Operations
    module Update
      module ClassMethods
        # Updates a object
        # @param [Integer] id The id of the object that should be updated
        # @param [Hash] attributes The attributes that should be updated
        def update(attributes = {})
          id = attributes.delete(:id)
          session = attributes.delete(:session)
          response = RedboothRuby.request(:put,
                                          nil,
                                          api_member_url(id, :updated),
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
