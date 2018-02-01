require 'spec_helper'

describe Dradis::Plugins::Saint::FieldProcessor do
  let (:xml_file) { File.expand_path('spec/fixtures/files/full_report.xml') }

  before do
    @doc = Nokogiri::XML(File.read(xml_file))
    @doc = @doc.xpath('./report/overview').first
  end

  describe "#value" do
    context "for hosts and vulnerabilities" do
      before do
        @test_xml = @doc.xpath('./hosts/host').first
      end

      it "returns the value of the item's tag" do
        processor = described_class.new(data: @test_xml)
        value = processor.value(field: 'host.hostname')

        expect(value).to eq("Test Hostname")
      end
    end

    context "for evidences" do
      before do
        @test_xml = @doc.xpath('./vulnerabilities/host_info/vulnerability').first
        @test_xml.name = 'evidence'
      end

      it "returns the value for the class attribute" do
        processor = described_class.new(data: @test_xml)
        value = processor.value(field: 'evidence.class')

        expect(value).to eq("Test Vuln class")
      end
    end
  end
end
