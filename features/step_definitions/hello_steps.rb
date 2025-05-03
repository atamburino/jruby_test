require 'selenium-webdriver'

def navigate_to_login_page
  @driver.navigate.to "https://the-internet.herokuapp.com/login"
end

def enter_credentials(username, password)
  @driver.find_element(name: 'username').send_keys(username)
  @driver.find_element(name: 'password').send_keys(password)
  @driver.find_element(css: '.radius').click
end

def find_flash_message
  wait = Selenium::WebDriver::Wait.new(timeout: 20)
  wait.until { @driver.find_element(css: 'div#flash') }
end

When('I open the login page') do
  navigate_to_login_page
end

Then('I should see the correct page title') do
  expect(@driver.title).to include("The Internet")
end

When('I enter {string} credentials') do |type|
  credentials = {
    'valid admin' => ['admin@example.com', 'adminpass'],
    'valid user' => ['user@example.com', 'userpass'],
    'invalid' => ['wrong@gmail.com', 'wrong']
  }
  username, password = credentials[type]
  enter_credentials(username, password)
end

Then('I should see the {string} message') do |message_type|
  flash = find_flash_message
  expected_messages = {
    'error' => 'Your username is invalid!',
    'account lockout' => 'Your account is locked!',
    'success' => 'Success'
  }
  expect(flash.text.strip).to include(expected_messages[message_type])
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
