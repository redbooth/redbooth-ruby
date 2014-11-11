module RedboothRuby
  module Operations
    module Show
      module ClassMethods
        # Shows a given object
        #
        # @param [Integer] id The id of the object that should be shown
        # @return [Copy::Base] The found object
        def show(attributes={})
          response = RedboothRuby.request(:get,
                                          nil,
                                          api_member_url(attributes[:id], :show),
                                          {},
                                          options_for_request(attributes)
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
