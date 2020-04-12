require 'selenium-webdriver'
require 'nokogiri'
require 'capybara/rails'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :chrome
  config.default_max_wait_time = 10
  config.server = :puma
  config.exact = true
  config.app_host = 'https://warm-taiga-57018.herokuapp.com/'
end
