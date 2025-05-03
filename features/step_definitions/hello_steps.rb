require 'selenium-webdriver'

# This file contains step definitions for the login feature tests using Selenium WebDriver.

# Navigates to the login page of the application.
def navigate_to_login_page
  @driver.navigate.to "https://the-internet.herokuapp.com/login"
end

# Enters the provided username and password into the login form and submits it.
def enter_credentials(username, password)
  @driver.find_element(name: 'username').send_keys(username)
  @driver.find_element(name: 'password').send_keys(password)
  @driver.find_element(css: '.radius').click
end

# Waits for and retrieves the flash message element that appears after an action.
def find_flash_message
  wait = Selenium::WebDriver::Wait.new(timeout: 20)
  wait.until { @driver.find_element(css: 'div#flash') }
end

# Step definition for opening the login page.
When('I open the login page') do
  navigate_to_login_page
end

# Step definition for entering credentials based on the type (e.g., valid admin, valid user, invalid).
When('I enter {string} credentials') do |type|
  # Define a hash mapping credential types to username and password pairs.
  credentials = {
    'valid admin' => ['admin@example.com', 'adminpass'],
    'valid user' => ['user@example.com', 'userpass'],
    'invalid' => ['wrong@gmail.com', 'wrong']
  }
  username, password = credentials[type]
  enter_credentials(username, password)
end

# Step definition for verifying the flash message content based on the message type.
Then('I should see the {string} message') do |message_type|
  flash = find_flash_message
  # Define a hash mapping message types to expected message content.
  expected_messages = {
    'error' => 'Your username is invalid!',
    'account lockout' => 'Your account is locked!',
    'success' => 'Success'
  }
  expect(flash.text.strip).to include(expected_messages[message_type])
end

# Step definition for clicking the forgot password link.
When('I click on the forgot password link') do
  @driver.find_element(link_text: 'Forgot Password').click
end

# Step definition for entering an email address for password recovery.
When('I enter my email address') do
  @driver.find_element(name: 'email').send_keys('user@example.com')
  @driver.find_element(css: 'button').click
end

# Step definition for simulating the receipt of a password recovery email.
Then('I should receive a password recovery email') do
  # Simulate email check or use a mock
  puts 'Password recovery email sent.'
end

# Step definition for entering invalid credentials multiple times to simulate account lockout.
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
