require 'zip'

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
      set_progress(20)
      @course[:modules] = reorganize_organization(@manifest)
      set_progress(30)
      @course[:file_map] = create_file_map(@manifest)
      set_progress(40)
      @course[:all_files_zip] = package_course_files(@course)

      save_to_file
      delete_unzipped_archive
      @course
    end

    def resources
      @resources
    end

    def create_file_map(manifest)
      file_map = {}

      manifest.css("resource[type=webcontent][href$='.html']").each do |res|
        file = {}
        file[:migration_id] = res['identifier']
        file[:path_name] = res['href']
        file[:file_name] = File.basename file[:path_name]
        file[:type] = 'FILE_TYPE'

        file_map[file[:migration_id]] = file
      end

      file_map
    end

    def package_course_files(course)
      zip_file = File.join(@base_export_dir, 'all_files.zip')
      make_export_dir
      path = @unzipped_file_path
      Zip::File.open(zip_file, 'w') do |zipfile|
        course[:file_map].each_value do |val|
          file_path = File.join(path, val[:real_path] || val[:path_name])
          val.delete :real_path
          if File.exist?(file_path)
            zipfile.add(val[:path_name], file_path)
          else
            add_warning(I18n.t('canvas.migration.errors.file_does_not_exist', 'The file "%{file_path}" did not exist in the content package and could not be imported.', :file_path => file_path))
          end
        end
      end
      File.expand_path(zip_file)
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
