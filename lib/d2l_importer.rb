require_relative "d2l_importer/version"
require "rails"
require_relative "d2l_importer/engine"
# require_relative "d2l_importer/converter"

module D2lImporter
  module Canvas

  end
  autoload :Converter, 'd2l_importer/converter'
  autoload :WikiBuilder, 'd2l_importer/wiki_builder'
  autoload :ResourceConsumer, 'd2l_importer/resource_consumer'
  autoload :OrganizationReorganizer, 'd2l_importer/organization_reorganizer'
  autoload :ConsumeFiles, 'd2l_importer/consume_files'
  autoload :D2lDiscussionConverter, 'd2l_importer/d2l_discussion_converter'
  autoload :D2lQuizConverter, 'd2l_importer/d2l_quiz_converter'
end
