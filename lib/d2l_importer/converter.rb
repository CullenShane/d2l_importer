module D2lImporter
  class Converter < Canvas::Migration::Migrator
    def initialize(settings)
      super(settings, "d2l")
    end
  end
end
