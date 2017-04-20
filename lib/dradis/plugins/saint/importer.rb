module Dradis::Plugins::Saint
  class Importer < Dradis::Plugins::Upload::Importer
    def import(params={})
      file_content = File.read(params[:file])

      logger.info {'Parsing SAINT output file...'}
      doc = Nokogiri::XML( file_content )
      logger.info{'Done.'}

      doc.xpath('/report').each do |xml_report|
        logger.info {'Processing report...'}
        xml_report.xpath('./details/vulnerability').each do |vuln|
          process_vuln_issue(vuln)
        end

        xml_report.xpath('./overview/hosts/host').each do |host|
          process_host_item(host)
        end

        logger.info {'Report processed...'}
      end

      true
    end

    private
    def process_vuln_issue(xml_vuln)
      logger.info{ "\t\t => Creating new issue..." }
      plugin_id = Digest::SHA1.hexdigest(xml_vuln.xpath('./description').first.text) 

      issue_text = template_service.process_template(template: 'vulnerability', data: xml_vuln)
      issue = content_service.create_issue(text: issue_text, id: plugin_id)
    end

    def process_host_item(xml_host)
      # Create Dradis Node
      host_name = xml_host.xpath('./hostname').first.text || "Unnamed host"
      host_node = content_service.create_node(label: host_name, type: :host)
      logger.info{ "\tHost: #{host_name}" }

      # Create note for the new node
      host_note_text = template_service.process_template(template: 'host', data: xml_host)
      content_service.create_note(text: host_note_text, node: host_node)
    end
  end
end
