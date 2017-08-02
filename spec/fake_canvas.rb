# This is a fake canvas for faking things
module ::Canvas
  module Migration
    class Migrator
      SCRAPE_ALL_HASH = { 'course_outline' => true, 'announcements' => true, 'assignments' => true, 'goals' => true, 'rubrics' => true, 'web_links' => true, 'learning_modules' => true, 'calendar_events' => true, 'calendar_start' => nil, 'calendar_end' => nil, 'discussions' => true, 'assessments' => true, 'question_bank' => true, 'all_files' => true, 'groups' => true, 'assignment_groups' => true, 'tasks' => true, 'wikis' => true }
      def initialize(settings, migration_type)
        raise "Settings must be set" if settings.empty?
      end

      def export(scope={})
        raise "Must be implemented by other peeps"
      end

      def unzip_archive

      end
    end
  end
end
