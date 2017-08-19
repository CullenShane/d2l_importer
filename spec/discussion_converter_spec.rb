require 'spec_helper'

describe D2lImporter::Converter::DiscussionConverter do
  let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }

  context '#convert_discussions' do
    let(:resources) { {'res_discuss_1' => {href: 'discussion_d2l_1.xml', material_type: 'd2ldiscussion', type: 'webcontent'},
     'res_quiz_1' => {href: 'quiz_1.xml', material_type: 'd2lquiz', type: 'webcontent'}} }
    subject { converter.convert_discussions(resources) }
    it 'should consume only discussions' do
      expect(converter).to receive(:discuss_this).with(resources['res_discuss_1'][:href]) {  }
      expect{subject}.not_to raise_error
      expect(subject.length).to eq 1
    end
  end

  context '#discuss_this' do
    let(:discussion_path) { 'discussion_d2l_1.xml' }
    subject { converter.discuss_this(discussion_path) }
    it 'should convert the file contents' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject.keys).to include :migration_id, :position, :require_initial_post, :title, :description
    end
  end

end
