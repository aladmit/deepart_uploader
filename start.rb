require 'pry'
require 'capybara/poltergeist'
require 'phantomjs'
require './deepart.rb'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
                                    phantomjs: Phantomjs.path,
                                    js_errors: false,
                                    phantomjs_options: ["--ignore-ssl-errors=yes",
                                                        "--ssl-protocol=any"
                                                       ]
                                   )
end
Capybara.default_driver = :poltergeist

browser = Capybara.current_session
deepart = Deepart.new(browser)
photo_paths = Dir["#{ARGV[0]}*"]
style_path = ARGV[1]

deepart.login
photo_paths.each_with_index do |photo_path, index|
  print "Upload image #{index + 1}/#{photo_paths.size}\n"
  deepart.create_image(photo_path, style_path)
end

puts "All images were upload."
