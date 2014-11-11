module RedboothRuby
  class Base
    include RedboothRuby::Operations::Base

    attr_accessor :created_time

    # Initializes the object using the given attributes
    #
    # @param [Hash] attributes The attributes to use for initialization
    def initialize(attributes = {})
      set_attributes(attributes)
      parse_timestamps
    end

    # Model validations
    #
    # @return [Boolean]
    def valid?
      errors.empty?
    end

    # Accesor for the errors
    #
    def errors
      @errors || []
    end

    # Sets the attributes
    #
    # @param [Hash] attributes The attributes to initialize
    def set_attributes(attributes)
      attributes.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # Parses UNIX timestamps and creates Time objects.
    def parse_timestamps
      @created_time = created_time.to_i if created_time.is_a? String
      @created_time = Time.at(created_time) if created_time
    end
  end
end
