
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
      get_all_resources(@manifest)


      delete_unzipped_archive
      @course
    end

    def resources
      @resources
    end

    def get_all_resources(manifest)
      manifest.css('resource').each do |r_node|
        id = r_node['identifier']
        resource = @resources[id]
        resource ||= {:migration_id=>id}
        resource[:type] = r_node['type']
        resource[:href] = r_node['href']
        if resource[:href]
          resource[:href] = resource[:href].gsub('\\', '/')
        else
          #it could be embedded in the manifest
          @resource_nodes_for_flat_manifest[id] = r_node
        end
        # Should be "Learner", "Instructor", or "Mentor"
        resource[:intended_user_role] = get_node_val(r_node, "intendedEndUserRole value", nil)
        # Should be "assignment", "lessonplan", "syllabus", or "unspecified"
        resource[:intended_use] = r_node['intendeduse']
        resource[:files] = []
        r_node.css('file').each do |file_node|
          resource[:files] << {:href => file_node[:href].gsub('\\', '/')}
        end
        resource[:dependencies] = []
        r_node.css('dependency').each do |d_node|
          resource[:dependencies] << d_node[:identifierref]
        end
        if variant = r_node.at_css('variant')
          resource[:preferred_resource_id] = variant['identifierref']
        end
        @resources[id] = resource
      end
    end
  end
end
