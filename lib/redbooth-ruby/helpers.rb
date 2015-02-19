module RedboothRuby
  module Helpers

    # Transform a resource name into a class name.
    # Transform a Symbol|String:
    #   capitalize the first letter
    #   capitalize the first letter after _'s, removing the _'s
    # Example: camelize(:task_list)   # => TaskList
    # Example: camelize('task_list')  # => TaskList
    #
    # @param  [Symbol|String] name to convert
    # @return [String] string of the class name
    def camelize(name)
      name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    # Transform a class name into a resource name.
    # Downcase all the letters, inserting an underscore _ before capitals
    # Example: underscore('TaskList')   # => task_list
    #
    # @param  [String] camel_case_word to convert
    # @return [String] string of the resource name
    def underscore(camel_case_word)
      camel_case_word.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

  end
end
