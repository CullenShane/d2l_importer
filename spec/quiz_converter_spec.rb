describe QuizConverter do
  let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }

  context '#convert_quizes' do
    let(:resources) { {'res_discuss_1' => {href: 'discussion_d2l_1.xml', material_type: 'd2ldiscussion', type: 'webcontent'},
                       'res_quiz_1' => {href: 'quiz_1.xml', material_type: 'd2lquiz', type: 'webcontent'}} }
    subject { converter.convert_quizzes(resources) }
    it 'should consume only quizzes' do
      expect(converter).to receive(:convert_this_quiz).with(resources['res_quiz_1'][:href]) {  }
      expect{subject}.not_to raise_error
      expect(subject.length).to eq 1
    end
  end

  context '#convert_this_quiz' do
    let(:discussion_path) { 'quiz_d2l_1.xml' }
    subject { converter.convert_this_quiz(discussion_path) }
    it 'should convert the file contents' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject.keys).to include :migration_id, :title
    end
  end
end
