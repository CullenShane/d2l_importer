require 'nokogiri'
# This is a fake canvas for faking things

module ::Canvas
  module Migration
    class Migrator
      SCRAPE_ALL_HASH = { 'course_outline' => true, 'announcements' => true, 'assignments' => true, 'goals' => true, 'rubrics' => true, 'web_links' => true, 'learning_modules' => true, 'calendar_events' => true, 'calendar_start' => nil, 'calendar_end' => nil, 'discussions' => true, 'assessments' => true, 'question_bank' => true, 'all_files' => true, 'groups' => true, 'assignment_groups' => true, 'tasks' => true, 'wikis' => true }
      def initialize(settings, migration_type)
        raise "Settings must be set" if settings.empty?
        @course = {}
        @unzipped_file_path = settings[:unzipped_file_path]
        @base_export_dir = File.join(__dir__,'fixtures','export')
        @unzipped_file_path = File.join(__dir__,'fixtures')
      end

      def export(scope={})
        raise "Must be implemented by other peeps"
      end

      def unzip_archive
        clean_up
      end
      def delete_unzipped_archive
        clean_up
      end
      def save_to_file; end
      def make_export_dir; end
      def set_progress(progress); end
      def get_all_resources(manifestfile); end
      def add_warning(arg); end

      private

      def clean_up
        file = File.join(@base_export_dir, 'all_files.zip')
        File.delete file if File.exists? file
      end
    end
    module XMLHelper
      def open_file(path)
        ::Nokogiri::HTML File.open(path)
      end

      def get_node_val(node, selector, default=nil)
        node.at_css(selector) ? node.at_css(selector).text : default
      end
    end
  end
end
