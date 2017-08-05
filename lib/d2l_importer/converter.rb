
module D2lImporter
  class Converter < ::Canvas::Migration::Migrator
    include ::Canvas::Migration
    include ::Canvas::Migration::XMLHelper

    def initialize(settings)
      super(settings, 'd2l')
      @course = @course.with_indifferent_access
      @resources = {}
    end

    MANIFEST_FILE = 'imsmanifest.xml'

    def export(to_export = SCRAPE_ALL_HASH)
      unzip_archive
      set_progress(5)

      @manifest = open_file(File.join(@unzipped_file_path, MANIFEST_FILE))
      consume_resources(@manifest)


      delete_unzipped_archive
      @course
    end

    def resources
      @resources
    end

    def consume_resources(manifest)
      manifest.css('resource').each do |r_node|
        id = r_node['identifier']
        resource = @resources[id]
        resource ||= {:migration_id=>id}
        resource[:type] = r_node['type']
        resource[:href] = r_node['href']
        if resource[:href]
          resource[:href] = resource[:href].gsub('\\', '/')
        end
        resource[:material_type] = r_node.find {|k,v| k.match('material_type') }[1]
        @resources[id] = resource
      end
      @resources
    end
  end
end
