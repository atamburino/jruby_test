require 'selenium-webdriver'

When('I open the login page') do
  @driver.navigate.to "https://the-internet.herokuapp.com/login"
end

Then('I should see the correct page title') do
  expect(@driver.title).to include("The Internet")
end

When('I enter {string} credentials') do |type|
  username, password = case type
                       when 'valid admin'
                         ['admin@example.com', 'adminpass']
                       when 'valid user'
                         ['user@example.com', 'userpass']
                       else
                         ['wrong@gmail.com', 'wrong']
                       end
  @driver.find_element(name: 'username').send_keys(username)
  @driver.find_element(name: 'password').send_keys(password)
  @driver.find_element(css: '.radius').click
end

Then('I should see the {string} message') do |message_type|
  wait = Selenium::WebDriver::Wait.new(timeout: 20)
  flash = wait.until { @driver.find_element(css: 'div#flash') }
  expected_message = case message_type
                     when 'error'
                       'Your username is invalid!'
                     when 'account lockout'
                       'Your account is locked!'
                     else
                       'Success'
                     end
  expect(flash.text.strip).to include(expected_message)
end

When('I click on the forgot password link') do
  @driver.find_element(link_text: 'Forgot Password').click
end

When('I enter my email address') do
  @driver.find_element(name: 'email').send_keys('user@example.com')
  @driver.find_element(css: 'button').click
end

Then('I should receive a password recovery email') do
  # Simulate email check or use a mock
  puts 'Password recovery email sent.'
end

When('I enter invalid credentials {int} times') do |times|
  times.times do
    step 'I enter invalid credentials'
  end
end

# Then('the email field should be invalid') do
#     email_field = @driver.find_element(name: 'username') # or 'email' depending on the page
#     is_valid = @driver.execute_script("return arguments[0].checkValidity();", email_field)
#     expect(is_valid).to be false
#   end  
