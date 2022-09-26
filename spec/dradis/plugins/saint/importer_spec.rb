require 'spec_helper'

describe Dradis::Plugins::Saint::Importer do
  before(:each) do
    # Stub template service
    templates_dir = File.expand_path('../../../../../templates', __FILE__)
    expect_any_instance_of(Dradis::Plugins::TemplateService)
    .to receive(:default_templates_dir).and_return(templates_dir)

    plugin = Dradis::Plugins::Saint

    @content_service = Dradis::Plugins::ContentService::Base.new(
      logger: Logger.new(STDOUT),
      plugin: plugin
    )

    @importer = described_class.new(
      content_service: @content_service
    )

    allow(@content_service).to receive(:create_note) do |args|
      OpenStruct.new(args)
    end

    allow(@content_service).to receive(:create_evidence) do |args|
      OpenStruct.new(args)
    end

    allow(@content_service).to receive(:create_issue) do |args|
      OpenStruct.new(args)
    end

    allow(@content_service).to receive(:create_node) do |args|
      obj = OpenStruct.new(args)
      obj.define_singleton_method(:set_property) { |*| }
      obj
    end
  end

  it 'creates the appropriate Dradis items for Saint v8 output' do
    expect(@content_service).to receive(:create_issue).exactly(8).times
    expect(@content_service).to receive(:create_node).with(hash_including label: '192.168.150.163').once

    @importer.import(file: 'spec/fixtures/files/saint_metasploitable_v8_sample.xml')
  end

  it 'creates the appropriate Dradis items for Saint v9 output' do
    expect(@content_service).to receive(:create_issue) do |args|
      expect(args[:text]).to include('server is susceptible to BEAST attack')
    end.once

    expect(@content_service).to receive(:create_node).with(hash_including label: '192.168.150.163').once

    @importer.import(file: 'spec/fixtures/files/saint_metasploitable_v9_sample.xml')
  end
end
