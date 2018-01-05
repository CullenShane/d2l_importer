define [
  'jquery'
  'compiled/views/content_migrations/ConverterViewControl'
  'compiled/views/content_migrations/subviews/ChooseMigrationFileView'
  'compiled/views/content_migrations/subviews/SelectContentCheckboxView'
  'compiled/views/content_migrations/subviews/QuestionBankView'
  'compiled/plugins/d2l_importer/views/content_migrations/D2lZipView'
  'compiled/bundles/modules/content_migration_setup'
], ($,
  ConverterViewControl,
  ChooseMigrationFileView,
  SelectContentCheckboxView,
  QuestionBankView,
  D2lZipView) ->


  ConverterViewControl.register
    key: 'd2l_converter'
    view: new D2lZipView
      chooseMigrationFile: new ChooseMigrationFileView
        model: ConverterViewControl.getModel()
        fileSizeLimit: ENV.UPLOAD_LIMIT

      selectContent:       new SelectContentCheckboxView(model: ConverterViewControl.getModel())

      questionBank:        new QuestionBankView
        model: ConverterViewControl.getModel()
        questionBanks: ENV.QUESTION_BANKS
