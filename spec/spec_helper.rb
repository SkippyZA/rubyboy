require "simplecov"

SimpleCov.start do
  coverage_dir "coverage"
  add_filter "/spec/"
end

require "bundler/setup"
require "rubyboy"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
end
