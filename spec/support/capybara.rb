require 'capybara/rspec'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 5
Capybara.server = :puma
Capybara.default_driver = :rack_test 