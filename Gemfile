source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

# Core Rails gems
gem "rails", "~> 7.1"
gem "actionpack", "~> 7.1"
gem "actionmailer", "~> 7.1"
gem "activerecord", "~> 7.1"
gem "activemodel", "~> 7.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sassc-rails"
gem "bootstrap-sass"

# Required gems from Tyler's Guide
gem 'paranoia'
gem 'memoist'
gem 'authlogic'
gem 'scrypt'
gem 'kaminari'
gem 'httparty'
gem 'resque'
gem 'resque-retry'
gem 'resque-timeout'

# JavaScript libraries will be handled via importmaps

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'database_cleaner-active_record'
end

