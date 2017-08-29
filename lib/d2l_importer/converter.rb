require 'zip'

module D2lImporter
  class Converter < ::Canvas::Migration::Migrator
    include ::Canvas::Migration
    include ::Canvas::Migration::XMLHelper
    include ResourceConsumer
    include OrganizationReorganizer
    include ConsumeFiles
    include WikiBuilder
    include DiscussionConverter
    include QuizConverter


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
      @course[:wikis] = create_wikis(@manifest)
      set_progress(30)
      @course[:discussion_topics] = convert_discussions(@resources)
      set_progress(40)
      @course[:assessment_questions] = convert_questions(@resources)
      @course[:assessments] = convert_quizzes(@resources)
      set_progress(50)
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
  end
end
