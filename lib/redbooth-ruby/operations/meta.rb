module RedboothRuby
  module Operations
    module Meta
      # Returns a hash with the object metadata
      #
      # @return [Hash] the object metadata
      def metadata
        response = RedboothRuby.request(:get, nil, 'metadata',
                                        { target_id: id, target_type: self.class.to_s },
                                        options_for_request({}))
        response.data
      end
    end
  end
end
