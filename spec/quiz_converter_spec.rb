describe D2lQuizConverter do
  let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }

  context '#convert_quizes' do
    let(:resources) { {'res_discuss_1' => {href: 'discussion_d2l_1.xml', material_type: 'd2ldiscussion', type: 'webcontent'},
                       'res_quiz_1' => {href: 'quiz_1.xml', material_type: 'd2lquiz', type: 'webcontent'}} }
    subject { converter.convert_d2l_quizzes(resources) }
    it 'should consume only quizzes' do
      expect(converter).to receive(:convert_this_quiz).with(resources['res_quiz_1'][:href]) {  }
      expect{subject}.not_to raise_error
      expect(subject.length).to eq 1
    end
  end

  context '#convert_questions' do
    let(:resources) { { 'res_question_library' => {href: 'questiondb.xml', material_type: 'd2lquestionlibrary', type: 'webcontent'} }}
    subject{ converter.convert_d2l_questions(resources) }
    it 'should consume questiondb.xml' do
      expect{subject}.not_to raise_error
      expect(subject.length).to eq 1
      expect(subject['assessment_questions'].length).to be <= 1
    end
  end

  context '#convert_this_quiz' do
    let(:discussion_path) { 'quiz_d2l_1.xml' }
    subject { converter.convert_this_quiz(discussion_path) }
    it 'should convert the file contents' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject.keys).to include :migration_id, :title
      expect(subject[:migration_id]).to eq 'idealnmsupp-92981'
      # Assignment migration id causes problems because there's no assignments yet.
      expect(subject.keys).not_to include :assignment_migration_id
    end
  end
end
