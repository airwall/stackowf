source 'https://rubygems.org'

ruby '2.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0.rc1'
# Use sqlite3 as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'slim-rails'
gem 'devise'
gem 'omniauth', '~> 1.3', '>= 1.3.1'
gem 'omniauth-facebook', '~> 3.0'
gem 'omniauth-twitter'
gem 'devise-bootstrap-views'

#Add unique ID's to div tag
gem 'record_tag_helper'

#FileUploader
gem 'carrierwave'
#Permit AJAX to file upload
gem 'remotipart', github: 'urielhdz/remotipart', ref: 'master'
#Nested forms
gem "cocoon"

gem "responders"
#JS templates
gem 'skim'
gem 'gon'

#authorization
gem "pundit"

#REST API
gem 'doorkeeper'

#Serializer
gem 'active_model_serializers', '~> 0.10.0'
gem 'oj'
gem 'oj_mimic_json'

#baccround jobs
gem 'sidekiq'
gem 'whenever'

#sphinx search
gem 'mysql2'
gem 'thinking-sphinx'

gem 'dotenv-rails'
gem 'therubyracer'

#markdown
gem 'redcarpet'
gem 'pygments.rb'
gem 'rails-bootstrap-markdown'

#caching
gem 'redis-rails'



group :test do
  gem 'capybara-screenshot'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'poltergeist'
  gem 'with_model'
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'json_spec', '~> 1.1', '>= 1.1.4'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  gem 'rspec', '~> 3.5.0.beta3'
  gem 'rspec-rails', '~> 3.5.0beta3'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'parallel_tests'
  gem 'capybara-email'
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener_web', '~> 1.2.0'
end

group :production do
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
