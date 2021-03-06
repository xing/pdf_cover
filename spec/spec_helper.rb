$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

ENV["RAILS_ENV"] ||= "test"

# Code coverage
require "coveralls"
Coveralls.wear!

# Development dependencies
require "byebug"
require "paperclip"
require "paperclip/matchers"
require "carrierwave"
require "RMagick"

# The gem itself
require "pdf_cover"

RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.profile_examples = 10
  config.order = :random
  config.default_formatter = "Fivemat"
  config.expose_dsl_globally = true
end
