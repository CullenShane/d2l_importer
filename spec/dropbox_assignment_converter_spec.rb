require 'spec_helper'

describe D2lImporter::Converter::DropboxAssignmentConverter do
  let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }

  context '#convert_dropboxes' do
    let(:resources) { {'res_discuss_1' => {href: 'discussion_d2l_1.xml', material_type: 'd2ldiscussion', type: 'webcontent'},
                       'res_quiz_1' => {href: 'quiz_1.xml', material_type: 'd2lquiz', type: 'webcontent'},
    'res_dropbox' => {href: 'dropbox_d2l.xml', material_type: 'd2ldropbox', type: 'webcontent'}}}
    subject { converter.convert_dropboxes(resources) }
    it 'will only consume dropboxes' do
      expect(converter).to receive(:drop_this_box).with(resources['res_dropbox'][:href]) { [{}] }
      expect{subject}.not_to raise_error
      expect(subject.length).to eq 1
    end
  end

  context '#drop_this_box' do
    let(:href) { 'dropbox_d2l.xml' }
    subject { converter.drop_this_box(href) }
    it 'should convert the file contents' do
      expect{subject}.not_to raise_error
      expect(subject).to be_an Array
      expect(subject.first).to be_a Hash
      expect(subject.first.keys).to include :migration_id, :instructions, :instructions_in_html, :submission_format, :grading_type, :points_possible, :title
    end
  end

end
