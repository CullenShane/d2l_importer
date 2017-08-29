module QuizConverter

  def convert_quizzes(resources)
    assessments = {}
    assessments[:assessments] = []

    resources_by(resources, 'd2lquiz', :material_type).each do |res|
      assessments[:assessments] << self.convert_this_quiz(res[:href])

    end

    assessments
  end

  def convert_this_quiz(file_path)
    quiz = {}
    File.open(File.join(@unzipped_file_path, file_path)) do |file|
      questions, assessments = Qti.convert_xml(file.read, {flavor: Qti::Flavors::D2L})
      quiz = assessments.first
      quiz[:questions] = [*quiz[:questions], *questions]
      quiz[:question_count] = quiz[:questions].length
      quiz[:migration_id] = quiz[:title]
      quiz.delete(:assignment_migration_id)
    end
    quiz
  end

  def convert_questions(resources)
    assessment_questions = {}
    assessment_questions['assessment_questions'] = []
    resources_by(resources, 'd2lquestionlibrary', :material_type).each do |res|
      File.open(File.join(@unzipped_file_path, res[:href])) do |file|
        questions, assessments = Qti.convert_xml(file.read, {flavor: Qti::Flavors::D2L})
        assessment_questions['assessment_questions'] =
          [*assessment_questions['assessment_questions'], *questions]
      end
    end
    assessment_questions
  end

end
