require 'spec_helper'

describe D2lImporter::Converter::ResourceConsumer do

  context '#consume_resources' do
    let(:manifest) { ::Nokogiri::HTML File.open File.join(__dir__, 'fixtures','imsmanifest.xml') }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    subject { converter.consume_resources(manifest) }
    it 'will return a hash' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject['RES_CONTENT_42']).not_to be_nil
      expect(subject['RES_CONTENT_42']).to be_a Hash
      expect(subject['RES_CONTENT_42'].keys).to include :type, :migration_id, :href, :material_type
      expect(subject['RES_CONTENT_42'][:material_type]).to eq 'contentmodule'
      expect(subject['RES_CONTENT_244'][:material_type]).to eq 'content'
    end
  end

end
