require 'spec_helper'

describe D2lImporter::Converter::WikiBuilder do

  context '#create_wiki' do
    let(:manifest) { ::Nokogiri::HTML File.open File.join(__dir__, 'fixtures','imsmanifest.xml') }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    before do
      manifest.remove_namespaces!
      converter.consume_resources(manifest)
    end
    subject { converter.create_wikis(manifest) }
    it 'will return an array' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Array
      expect(subject).not_to be_empty
      expect(subject.length).to be 1
      expect(subject.first).to include :migration_id, :path_name, :file_name, :type, :text, :url_name, :title
    end
  end

end
