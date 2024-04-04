module Dradis::Plugins::Saint
  module Mapping
    DEFAULT_MAPPING = {
      evidence: {
        'Port' => '{{ saint[evidence.port] }}',
        'Severity' => '{{ saint[evidence.severity] }}',
        'Class' => '{{ saint[evidence.class] }}',
        'cve' => '{{ saint[evidence.cve] }}',
        'CVSS Base Score' => '{{ saint[evidence.cvss_base_score] }}'
      },
      vulnerability: {
        'Title' => '{{ saint[vulnerability.description] }}',
        'Host Name' => '{{ saint[vulnerability.hostname] }}',
        'IP Address' => '{{ saint[vulnerability.ipaddr] }}',
        'Host Type' => '{{ saint[vulnerability.hosttype] }}',
        'Scan Time' => '{{ saint[vulnerability.scan_time] }}',
        'Status' => '{{ saint[vulnerability.status] }}',
        'Severity' => '{{ saint[vulnerability.severity] }}',
        'CVE' => '{{ saint[vulnerability.cve] }}',
        'CVSS Base Score' => '{{ saint[vulnerability.cvss_base_score] }}',
        'Impact' => '{{ saint[vulnerability.impact] }}',
        'Background' => '{{ saint[vulnerability.background] }}',
        'Problem' => '{{ saint[vulnerability.problem] }}',
        'Resolution' => '{{ saint[vulnerability.resolution] }}',
        'Reference' => '{{ saint[vulnerability.reference] }}'
      }
    }.freeze

    SOURCE_FIELDS = {
      evidence: [
        'evidence.port',
        'evidence.severity',
        'evidence.class',
        'evidence.cve',
        'evidence.cvss_base_score'
      ],
      vulnerability: [
        'vulnerability.description',
        'vulnerability.hostname',
        'vulnerability.ipaddr',
        'vulnerability.hosttype',
        'vulnerability.scan_time',
        'vulnerability.status',
        'vulnerability.severity',
        'vulnerability.cve',
        'vulnerability.cvss_base_score',
        'vulnerability.impact',
        'vulnerability.background',
        'vulnerability.problem',
        'vulnerability.resolution',
        'vulnerability.reference'
      ]
    }.freeze
  end
end
