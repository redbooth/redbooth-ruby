require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'redbooth'
require 'rspec'
require 'webmock/rspec'
require 'pry'
require 'vcr'

# Requires support files
Dir[File.join(File.dirname(__FILE__), 'shared/**/*.rb')].each {|f| require f}

# VCR cassette configuration
VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com'
  config.cassette_library_dir     = 'spec/cassettes'
  config.hook_into                :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end
