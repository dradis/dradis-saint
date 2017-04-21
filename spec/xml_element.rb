shared_examples 'Saint XML element' do
  it 'responds to its supported fields' do
    doc = Nokogiri::XML(File.read(xml_file))
    object_name = described_class.to_s.split('::').last.downcase
    object = described_class.new(doc.xpath("./#{object_name}").first)
    object.supported_tags.each do |tag|
      expect(object.send(tag)).to eq("Test #{tag.to_s.humanize}")
    end
  end
end
