require "rails_helper"

RSpec.configure do |config|
  Capybara.save_and_open_page_path = "%screenshots%/"
  config.include FeatureHelper, type: :feature
  config.use_transactional_fixtures = false
  #======================
  config.before(:suite) do
    # Truncate database to clean up garbage from
    # interrupted or badly written examples
    DatabaseCleaner.clean_with(:truncation)

    # Seed dataase. Use it only for essential
    # to run application data.
    load "#{Rails.root}/db/seeds.rb"
  end

  config.around(:each) do |example|
    # Use really fast transaction strategy for all
    # examples except `js: true` capybara specs
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction

    # Start transaction
    DatabaseCleaner.cleaning do
      # Run example
      example.run
    end

    load "#{Rails.root}/db/seeds.rb" if example.metadata[:js]

    # Clear session data
    Capybara.reset_sessions!
  end
  #=======================
end
