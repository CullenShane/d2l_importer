# require_relative '../../../../../lib/canvas/migration'
# require_relative '../../../../../lib/canvas/migration/migrator_helper'
# require_relative '../../../../../lib/canvas/reloader'
# require_relative '../../../../../lib/config_file'
# require_relative '../../../../../lib/canvas/migration/archive'
# require_relative '../../../../../lib/canvas/migration/migrator'

module D2lImporter
  class Converter < ::Canvas::Migration::Migrator
    def initialize(settings)
      super(settings, "d2l")
    end

    def export(to_export = ::Canvas::Migration::Migrator::SCRAPE_ALL_HASH)
      puts "exports nothing"
    end
  end
end
