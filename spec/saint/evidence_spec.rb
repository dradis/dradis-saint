require 'spec_helper'
require 'xml_element'

describe Saint::Evidence do
  let(:xml_file) { File.expand_path('../../fixtures/files/evidence-01.xml', __FILE__) }

  it_behaves_like 'Saint XML element'
end
