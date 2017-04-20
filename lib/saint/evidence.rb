module Saint
  class Evidence < Base
    def supported_tags
      [ :port, :severity, :vuln_class, :cve, :cvss_base_score ]
    end

    def process_field_value(method)
      if method == :vuln_class
        method = :class
      end

      @xml.xpath("./#{method.to_s}").first.try(:text)
    end
  end
end
