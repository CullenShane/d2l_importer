require 'zip'

module D2lImporter
  class Converter < ::Canvas::Migration::Migrator
    include ::Canvas::Migration
    include ::Canvas::Migration::XMLHelper
    include ResourceConsumer
    include OrganizationReorganizer
    include ConsumeFiles
    include WikiBuilder
    include D2lDiscussionConverter
    include D2lQuizConverter
    include DropboxAssignmentConverter


    def initialize(settings)
      super(settings, 'd2l')
      @course = @course.with_indifferent_access
      @resources = {}
      @ignored_files = []
    end

    MANIFEST_FILE = 'imsmanifest.xml'

    def export(to_export = SCRAPE_ALL_HASH)
      unzip_archive
      set_progress(5)
      set_unzipped_file_path

      manifest_file_path = File.join(@unzipped_file_path, MANIFEST_FILE)
      @manifest = open_file(manifest_file_path)
      @ignored_files << manifest_file_path
      @manifest.remove_namespaces!
      set_progress(10)
      consume_resources(@manifest)
      set_progress(20)
      @course[:wikis] = create_d2l_wikis(@manifest)
      set_progress(30)
      @course[:discussion_topics] = convert_d2l_discussions(@resources)
      set_progress(40)
      @course[:assessment_questions] = convert_d2l_questions(@resources)
      @course[:assessments] = convert_d2l_quizzes(@resources)
      set_progress(50)
      @course[:assignments] = convert_dropboxes(@resources)
      set_progress(60)
      @course[:file_map] = create_d2l_file_map
      @course[:all_files_zip] = package_course_files(@course)
      set_progress(70)
      @course[:modules] = reorganize_organization(@manifest)
      save_to_file
      delete_unzipped_archive
      @course
    end

    def resources
      @resources
    end

    def resources_by(resources, key, *types)
      resources.values.find_all {|res|
        types.any?{|t|
          res[t].start_with?(key)
        }
      }
    end

    def set_unzipped_file_path
      @unzipped_file_path = @archive.unzipped_file_path
    end
  end
end
