$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

ENV["RAILS_ENV"] ||= "test"

# Code coverage
require "simplecov"
SimpleCov.start

# Development dependencies
require "byebug"
require "paperclip"
require "paperclip/matchers"
require "carrierwave"

# The gem itself
require "xing/pdf_cover"

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
