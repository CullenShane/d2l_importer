require 'spec_helper'

describe D2lImporter::Converter::ConsumeFiles do

  context '#create_file_map' do
    let(:manifest) { ::Nokogiri::HTML File.open File.join(__dir__, 'fixtures','imsmanifest.xml') }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    before do
      manifest.remove_namespaces!
      converter.consume_resources(manifest)
    end
    subject { converter.create_file_map(manifest) }
    it 'will return an array' do
      pending "This should consume files that AREN'T listed as resources instead"
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject).not_to be_empty
      expect(subject.length).to be 1
      expect(subject['RES_CONTENT_244'].keys).to include :migration_id, :path_name, :file_name, :type
    end
    context '#package_course_files' do
      let(:course) { { file_map: converter.create_file_map(manifest) } }
      subject { converter.package_course_files(course) }
      it 'will write a file' do
        pending "This should consume files that AREN'T listed as resources instead"
        expect{subject}.not_to raise_error
        expect(subject).to be_a String
        expect(File.exist? subject).to be true
      end
    end
  end

end
