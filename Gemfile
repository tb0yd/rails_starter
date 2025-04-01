source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Core Rails gems
gem 'rails', '~> 7.0.8'
gem 'pg', '~> 1.5.3'
gem 'puma', '~> 6.3.1'
gem 'sprockets-rails'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis', '~> 4.0'

# Required gems from Tyler's Guide
gem 'paranoia'
gem 'memoist'
gem 'authlogic'
gem 'kaminari'
gem 'httparty'
gem 'resque'
gem 'resque-retry'
gem 'resque-timeout'

# JavaScript libraries will be handled via importmaps

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
end

