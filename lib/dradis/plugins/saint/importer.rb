module Dradis::Plugins::Saint
  class Importer < Dradis::Plugins::Upload::Importer
    def import(params={})
      @issues = {}
      @hosts = {}
      file_content = File.read(params[:file])

      logger.info {'Parsing SAINT output file...'}
      doc = Nokogiri::XML( file_content )
      logger.info{'Done.'}

      if doc.xpath('/report').empty?
        error = "No reports were detected in the uploaded file (/report). Ensure you uploaded a SAINT XML report."
        logger.fatal{ error }
        content_service.create_note text: error
        return false
      end

      doc.xpath('/report').each do |xml_report|
        logger.info {'Processing report...'}

        # Process <host> tags
        xml_report.xpath('./overview/hosts/host').each do |host|
          process_host_item(host)
        end

        # Process <vulnerability> tags
        xml_report.xpath('./details/vulnerability').each do |vuln|
          process_vuln_issue(vuln)
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

    def process_evidence(xml_evidence, host_node_name)
      # Associate the xml tag as evidence
      xml_evidence.name = 'evidence'
      evidence_desc = xml_evidence.xpath('./description').first.text

      # Find the host node
      host_node = @hosts[host_node_name]

      if !host_node
        logger.error { "[WARNING] Cannot find an associated host for '#{evidence_desc}'." }
        return
      end

      # Find the related issue
      issue_plugin_id = Digest::SHA1.hexdigest(evidence_desc)
      issue = @issues[issue_plugin_id]

      evidence_text = template_service.process_template(template: 'evidence', data: xml_evidence)

      if issue
        # Create Dradis evidence
        logger.info{ "\t\t => Creating new evidence..." }
        content_service.create_evidence(issue: issue, node: host_node, content: evidence_text)
      else
        # Create Note in Host
        logger.info{ "\t\t => Creating note for host node..." }
        note_text = "#[Title]#\n#{evidence_desc}\n\n" + evidence_text
        content_service.create_note(text: note_text, node: host_node)
      end
    end

    def process_host_item(xml_host)
      # Create Dradis node
      host_name = xml_host.xpath('./hostname').first.text || "Unnamed host"
      host_node = content_service.create_node(label: host_name, type: :host)
      logger.info{ "\tHost: #{host_name}" }

      # Save the host for later to be linked to evidences
      @hosts[host_name] = host_node

      # Add properties to the node
      if xml_host.xpath('./ipaddr').first
        host_node.set_property(:ip, xml_host.xpath('./ipaddr').first.text)
      end
      if xml_host.xpath('./hosttype').first
        host_node.set_property(:os, xml_host.xpath('./hosttype').first.text)
      end
      host_node.set_property(:hostname, host_name)
      host_node.save
    end

    def process_vuln_issue(xml_vuln)
      element_desc = xml_vuln.xpath('./description').first.text

      # Check if the vulnerability is a real issue or a service
      if real_issue?(xml_vuln)
        # Create Dradis Issue
        logger.info{ "\t\t => Creating new issue..." }
        plugin_id = Digest::SHA1.hexdigest(element_desc)

        issue_text = template_service.process_template(template: 'vulnerability', data: xml_vuln)
        issue = content_service.create_issue(text: issue_text, id: plugin_id)
      else
        # Create Note in Host
        logger.info{ "\t\t => Creating note for host node..." }

        note_details = xml_vuln.xpath('./vuln_details').first.text
        note_text = "#[Title]#\n#{element_desc}\n\n" + note_details

        host_name = xml_vuln.xpath('./hostname').first.text || "Unnamed host"
        host_node = @hosts[host_name]
        content_service.create_note(text: note_text, node: host_node)
      end

      # Save the issue for later to be linked to evidences
      @issues[plugin_id] = issue
    end

    def real_issue?(xml_vuln)
      xml_vuln.xpath('./severity').first.text != 'Service'
    end
  end
end
