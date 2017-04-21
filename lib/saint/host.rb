module Saint
  class Host < Base
    def supported_tags
      [ :hostname, :ipaddr, :hosttype ]
    end

    def process_field_value(method)
      @xml.xpath("./#{method.to_s}").first.try(:text)
    end
  end
end
