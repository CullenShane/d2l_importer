module D2lImporter
  class Railtie < Rails::Engine
    isolate_namespace D2lImporter
    initializer "d2l_importer.canvas_plugin" do
      require 'd2l_importer/converter'
    end

    config.to_prepare do
      ::Canvas::Plugin.register :d2l_converter, :export_system, {
          :name => "D2L Importer",
          :author => 'Navigation North',
          :description => 'This enables importing from D2L export systems',
          :version => '1.0.0',
          :select_text => 'D2L .zip File',
          :settings => {
              # :migration_partial => 'd2l_config',
              :requires_file_upload => true,
              :worker=> 'CCWorker',
              :provides =>{:d2l=>D2lImporter::Converter},
              :valid_contexts => %w{Account Course}
          }
      }
    end
  end
end






