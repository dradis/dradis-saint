module Dradis::Plugins::Saint
  class Importer < Dradis::Plugins::Upload::Importer
    def import(params={})
      @issues = {}
      @hosts = {}
      file_content = File.read(params[:file])

      logger.info {'Parsing SAINT output file...'}
      doc = Nokogiri::XML( file_content )
      logger.info{'Done.'}

      doc.xpath('/report').each do |xml_report|
        logger.info {'Processing report...'}

        # Process <vulnerability> tags
        xml_report.xpath('./details/vulnerability').each do |vuln|
          process_vuln_issue(vuln)
        end

        # Process <host> tags
        xml_report.xpath('./overview/hosts/host').each do |host|
          process_host_item(host)
        end

        # Process <vulnerabilities> tag
        xml_report.xpath('./overview/vulnerabilities/host_info').each do |xml_host_info|
          host_name = xml_host_info.xpath('./hostname').first.text
          xml_host_info.xpath('./vulnerability').each do |evidence|
            process_evidence(evidence, host_name)
          end
        end

        logger.info {'Report processed...'}
      end

      true
    end

    private
    def process_vuln_issue(xml_vuln)
      # Create Dradis Issue
      logger.info{ "\t\t => Creating new issue..." }
      plugin_id = Digest::SHA1.hexdigest(xml_vuln.xpath('./description').first.text) 

      issue_text = template_service.process_template(template: 'vulnerability', data: xml_vuln)
      issue = content_service.create_issue(text: issue_text, id: plugin_id)

      # Save the issue for later to be linked to evidences
      @issues[plugin_id] = issue
    end

    def process_host_item(xml_host)
      # Create Dradis node
      host_name = xml_host.xpath('./hostname').first.text || "Unnamed host"
      host_node = content_service.create_node(label: host_name, type: :host)
      logger.info{ "\tHost: #{host_name}" }

      # Save the host for later to be linked to evidences
      @hosts[host_name] = host_node

      # Create note for the new node
      host_note_text = template_service.process_template(template: 'host', data: xml_host)
      content_service.create_note(text: host_note_text, node: host_node)
    end

    def process_evidence(xml_evidence, host_node_name)
      # Associate the xml tag as evidence
      xml_evidence.name = 'evidence'
      evidence_desc = xml_evidence.xpath('./description').first.text

      # Find the host node
      host_node = @hosts[host_node_name]

      if !host_node
        logger.error { "[ERROR] Cannot find an associated host for '#{evidence_desc}'." }
        return
      end

      # Find the related issue
      issue_plugin_id = Digest::SHA1.hexdigest(evidence_desc)
      issue = @issues[issue_plugin_id]

      if !issue
        logger.error { "[ERROR] Cannot find an associated vulnerability for '#{evidence_desc}'." }
        return
      end

      # Create Dradis evidence
      logger.info{ "\t\t => Creating new evidence..." }
      evidence_text = template_service.process_template(template: 'evidence', data: xml_evidence)
      content_service.create_evidence(issue: issue, node: host_node, content: evidence_text)
    end
  end
end
