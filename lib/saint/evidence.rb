module Saint
  class Evidence < Base
    def supported_tags
      [ :port, :severity, :vuln_class, :cve, :cvss_base_score ]
    end

    def process_field_value(method)
      # We cannot send the message 'class' to the saint_object because it
      # evaluates to the object's Ruby class. We temporarily rename the
      # field to 'vuln_class' and switch it back later when needed.
      if method == :vuln_class
        method = :class
      end

      @xml.xpath("./#{method.to_s}").first.try(:text)
    end
  end
end
