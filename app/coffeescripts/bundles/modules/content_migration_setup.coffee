define [
  'jquery'
  'compiled/views/content_migrations/ConverterViewControl'
  'compiled/views/content_migrations/subviews/ChooseMigrationFileView'
  'compiled/views/content_migrations/subviews/SelectContentCheckboxView'
  'compiled/views/content_migrations/subviews/QuestionBankView'
  'compiled/views/content_migrations/MoodleZipView'
], ($,
  ConverterViewControl,
  ChooseMigrationFileView,
  SelectContentCheckboxView,
  QuestionBankView,
  MoodleZipView) ->


  ConverterViewControl.register
    key: 'd2l_converter'
    view: new MoodleZipView
      chooseMigrationFile: new ChooseMigrationFileView
        model: ConverterViewControl.getModel()
        fileSizeLimit: ENV.UPLOAD_LIMIT

      selectContent:       new SelectContentCheckboxView(model: ConverterViewControl.getModel())

      questionBank:        new QuestionBankView
        model: ConverterViewControl.getModel()
        questionBanks: ENV.QUESTION_BANKS
