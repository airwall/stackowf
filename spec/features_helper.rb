require "rails_helper"
require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  Capybara.save_and_open_page_path = "%screenshots%/"
  config.include FeatureHelper, type: :feature
  config.use_transactional_fixtures = false
end

Capybara.default_max_wait_time = 5
OmniAuth.config.test_mode = true
