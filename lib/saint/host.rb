module Saint
  class Host
    def initialize(xml_node)
      @xml = xml_node
    end

    def supported_tags
      [ :ipaddr, :hosttype ]
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

      @xml.xpath("./#{method.to_s}").first.try(:text)
    end
  end
end
