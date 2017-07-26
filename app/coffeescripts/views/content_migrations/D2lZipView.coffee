define [
  'Backbone',
  'jst/content_migrations/D2lZip',
  'compiled/views/content_migrations/D2lZipView'
], (Backbone, template, D2lView) ->
  class D2lZip extends MigrationView
    template: template

    @child 'chooseMigrationView','.chooseMigrationView'
