require 'zip'
require_relative 'resource_consumer'
require_relative 'organization_reorganizer'
require_relative 'consume_files'

module D2lImporter
  class Converter < ::Canvas::Migration::Migrator
    include ::Canvas::Migration
    include ::Canvas::Migration::XMLHelper
    include ResourceConsumer
    include OrganizationReorganizer
    include ConsumeFiles

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
      @manifest.remove_namespaces!
      set_progress(10)
      consume_resources(@manifest)
      set_progress(20)
      # @course[:file_map] = create_file_map(@resources)
      set_progress(30)
      # @course[:all_files_zip] = package_course_files(@course)
      set_progress(40)
      @course[:modules] = reorganize_organization(@manifest)

      save_to_file
      delete_unzipped_archive
      @course
    end

    def resources
      @resources
    end

    def resources_by(key, *types)
      @resources.values.find_all {|res| types.any?{|t| res[key].start_with? t} }
    end
  end
end
