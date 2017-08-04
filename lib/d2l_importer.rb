require_relative "d2l_importer/version"
require "rails"
require_relative "d2l_importer/engine"
# require_relative "d2l_importer/converter"

module D2lImporter
  module Canvas

  end
  autoload :Converter, 'd2l_importer/converter'
end
