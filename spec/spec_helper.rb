$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

# Development dependencies
require "byebug"
require "paperclip"
require "carrierwave"

# The gem itself
require "xing/pdf_cover"

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.warnings = true
  config.profile_examples = 10
  config.order = :random
  config.default_formatter = "Fivemat"
  config.expose_dsl_globally = true
end
