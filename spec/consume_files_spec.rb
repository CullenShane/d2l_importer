require 'spec_helper'

describe D2lImporter::Converter::ConsumeFiles do

  context '#create_file_map' do
    let(:manifest) { ::Nokogiri::HTML File.open File.join(__dir__, 'fixtures','imsmanifest.xml') }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    subject { converter.create_d2l_file_map }
    it 'will return a map of files' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject['Meet your teacher!.html']).to be_a Hash
      expect(subject).not_to be_empty
      expect(subject.length).to be 7
      expect(subject['Meet your teacher!.html'].keys).to include :migration_id, :path_name, :file_name, :type
    end
    context '#package_course_files' do
      let(:course) { { file_map: converter.create_d2l_file_map } }
      subject { converter.package_course_files(course) }
      it 'will write a file' do
        expect{subject}.not_to raise_error
        expect(subject).to be_a String
        expect(File.exist? subject).to be true
      end
    end
  end

end
