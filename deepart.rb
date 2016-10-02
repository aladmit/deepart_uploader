require 'dotenv'

Dotenv.load

class Deepart
  def initialize(browser)
    @browser = browser
  end

  def login
    @browser.visit 'https://deepart.io/login/'
    @browser.fill_in 'email', with: ENV['DEEPART_LOGIN']
    @browser.fill_in 'password', with: ENV['DEEPART_PASSWORD']
    @browser.click_button 'Sign in'
  end

  def create_image(photo_path, style_path)
    @browser.visit 'https://deepart.io/hire/'
    drop_file(photo_path, 'upload-photo')
    @browser.click_link 'Upload style'
    drop_file(style_path, 'upload-style')
    sleep 10
    @browser.click_button 'Submit'
  end

  private


  def drop_file(file_path, id)
    @browser.execute_script <<-JS
      fakeFileInput = window.$('<input/>').attr(
        {id: 'fakeFileInput_#{id}', type:'file'}
      ).appendTo('body');
    JS

    @browser.attach_file("fakeFileInput_#{id}", file_path)

    @browser.execute_script("var fileList = [fakeFileInput.get(0).files[0]]")
    @browser.execute_script <<-JS
      var e = jQuery.Event('drop', { dataTransfer : { files : [fakeFileInput.get(0).files[0]] } });
      $('##{id} > .dropzone')[0].dropzone.listeners[0].events.drop(e);
    JS
  end
end
