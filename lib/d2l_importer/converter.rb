# require_relative '../../../../../lib/canvas/migration'
require_relative '../../../../../lib/canvas/migration/migrator_helper'
require_relative '../../../../../lib/canvas/reloader'
require_relative '../../../../../lib/config_file'
require_relative '../../../../../lib/canvas/migration/archive'
require_relative '../../../../../lib/canvas/migration/migrator'

module D2lImporter
  class Converter < Canvas::Migration::Migrator
    def initialize(settings)
      super(settings, "desire_2_learn_importer")
    end

    def export
      puts "exports nothing"
    end
  end
end
