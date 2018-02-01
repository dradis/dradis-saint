module Saint
  class Base
    def initialize(xml_node)
      @xml = xml_node
    end

    def supported_tags
      []
    end

    def respond_to?(method, include_private=false)
      return true if supported_tags.include?(method.to_sym)
      super
    end

    def method_missing(method, *args)
      unless supported_tags.include?(method)
        super
        return
      end

      return process_field_value(method)
    end

    def process_field_value(method)
      raise "Method #process_field_value not overridden!"
    end
  end
end
