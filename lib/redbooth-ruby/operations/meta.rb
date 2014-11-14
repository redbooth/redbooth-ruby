module RedboothRuby
  module Operations
    module Meta
      # Returns a hash with the object metadata
      #
      # @return [Hash] the object metadata
      def metadata
        response = RedboothRuby.request(:get, nil, 'metadata',
                                        { target_id: id, target_type: klass_name },
                                        { session: session })
        response.data
      end

      # Sets the given hash as the desired metadata
      #
      # @return [Hash] the object metadata
      def metadata=(hash)
        response = RedboothRuby.request(:post, nil, 'metadata',
                                        { target_id: id, target_type: klass_name, metadata: hash },
                                        { session: session })

        response.data
      end

      # Merges the given hash with the exiting metadata and set the result
      #
      # @return [Hash] the object metadata
      def metadata_merge(hash)
        response = RedboothRuby.request(:put, nil, 'metadata',
                                        { target_id: id, target_type: klass_name, metadata: hash },
                                        { session: session })

        response.data
      end

      protected

      # Return redbooth class name
      #
      # @return [String]
      def klass_name
        self.class.to_s.split('::').last
      end
    end
  end
end
