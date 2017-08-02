
module D2lImporter
  class Converter < ::Canvas::Migration::Migrator
    def initialize(settings)
      super(settings, "d2l")
    end

    def export(to_export = ::Canvas::Migration::Migrator::SCRAPE_ALL_HASH)
      unzip_archive
      @course = {}



    end
  end
end
