require "bundler/setup"
Bundler.setup
require "fake_canvas"
require "fake_qti"
require "d2l_importer"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
