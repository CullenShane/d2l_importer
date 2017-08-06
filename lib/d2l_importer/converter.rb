
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
      set_progress(10)
      consume_resources(@manifest)
      reorganize_organization(@manifest)


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

    def reorganize_organization(manifest)
      modules = []
      return modules unless manifest

      manifest.css('organizations organization > item').each do |item|
        mod = {items: []}
        mod[:migration_id] = item['identifier']
        add_child_items(item, mod)
        modules << mod
      end
      modules
    end

    def add_child_items(parent_item, mod)
      parent_item.children.each do |item|
        if item.name == 'title'
          mod[:title] = item.text
        else
          if item = process_item(item)
            mod[:items] << item
          end
        end
      end
    end

    def process_item(item_node)
      mod_item = nil
      res = @resources[item_node['identifierref']]
      return mod_item if res.nil?
      case res[:material_type]
        when 'contentmodule'
        when 'content'
          mod_item = {
            indent: 1,
            linked_resource_id: item_node['indentifierref'],
            linked_resource_title: get_node_val(item_node, 'title'),
            linked_resource_type: "FILE_TYPE"
          }
        when 'contentlink'

      end
      return mod_item
    end
  end
end
