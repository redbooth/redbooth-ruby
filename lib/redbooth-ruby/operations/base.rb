module RedboothRuby
  module Operations
    module Base
      module ClassMethods
        # Options for request
        # overwrite this in the model to set security
        #
        # @return [Hash]
        def options_for_request(attributes)
          fail AuthenticationError unless attributes[:session]
          {
            session: attributes[:session]
          }
        end

        protected

        # URl for the member endpoints
        # overwrite this in the model if the api is not well named
        #
        def api_member_url(id = nil, method = nil)
          url = api_resource_name(method)
          url += "/#{id}" if id
          url
        end

        # URl for the collection endpoints
        # overwrite this in the model if the api is not well named
        #
        def api_collection_url(attrs = {})
          api_resource_name
        end

        # resource name
        # overwrite this in the model if the api is not well named
        #
        def api_resource_name(method = nil)
          "#{name.split('::').last.downcase}s"
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
