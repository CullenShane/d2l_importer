define [
  'Backbone',
  'jst/plugins/d2l_importer/content_migrations/D2lZip'
  'compiled/views/content_migrations/MigrationView'
], (Backbone, template, MigrationView) ->
  class D2lZip extends MigrationView
    template: template

    @child 'chooseMigrationView','.chooseMigrationView'
