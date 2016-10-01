require 'pry'
require 'capybara/poltergeist'
require 'phantomjs'
require './deepart.rb'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs: Phantomjs.path)
end
Capybara.default_driver = :poltergeist

browser = Capybara.current_session
deepart = Deepart.new(browser)

deepart.login
deepart.create_image('./photo.jpg', './style.jpg')
