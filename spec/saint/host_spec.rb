require 'spec_helper'
require 'xml_element'

describe Saint::Host do
  let(:xml_file) { File.expand_path('../../fixtures/files/host-01.xml', __FILE__) }

  it_behaves_like 'Saint XML element'
end
