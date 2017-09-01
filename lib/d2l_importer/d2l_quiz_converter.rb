module D2lQuizConverter

  def convert_d2l_quizzes(resources)
    assessments = {}
    assessments[:assessments] = []

    resources_by(resources, 'd2lquiz', :material_type).each do |res|
      assessments[:assessments] << self.convert_this_quiz(res[:href])

    end

    assessments
  end

  def convert_this_quiz(file_path)
    quiz = {}
    quiz_file_path = File.join(@unzipped_file_path, file_path)
    @ignored_files << quiz_file_path
    File.open(quiz_file_path) do |file|
      questions, assessments = Qti.convert_xml(file.read, {flavor: Qti::Flavors::D2L})
      file.rewind
      quiz_xml = ::Nokogiri::HTML file
      quiz = assessments.first
      quiz[:questions] = [*quiz[:questions], *questions]
      quiz[:question_count] = quiz[:questions].length
      quiz[:migration_id] = quiz_xml.css('assessment').first['d2l_2p0:resource_code']
      quiz.delete(:assignment_migration_id)
    end
    quiz
  end

  def convert_d2l_questions(resources)
    assessment_questions = {}
    assessment_questions['assessment_questions'] = []
    resources_by(resources, 'd2lquestionlibrary', :material_type).each do |res|
      question_library_path = File.join(@unzipped_file_path, res[:href])
      @ignored_files << question_library_path
      File.open(question_library_path) do |file|
        questions, assessments = Qti.convert_xml(file.read, {flavor: Qti::Flavors::D2L})
        assessment_questions['assessment_questions'] =
          [*assessment_questions['assessment_questions'], *questions]
      end
    end
    assessment_questions
  end

end
