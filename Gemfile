source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

# Core Rails gems
gem 'rails', '~> 7.1'
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
end

