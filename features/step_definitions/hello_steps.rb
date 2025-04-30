require 'selenium-webdriver'

When('I open the login page') do
  @driver.navigate.to "https://the-internet.herokuapp.com/login"
end

Then('I should see the correct page title') do
  expect(@driver.title).to include("The Internet")
end

When('I enter invalid credentials') do
  @driver.find_element(name: 'username').send_keys('wrong@gmail.com')
  @driver.find_element(name: 'password').send_keys('wrong')
  @driver.find_element(css: '.radius').click
end

Then('I should see an error message') do
    wait = Selenium::WebDriver::Wait.new(timeout: 20)
    flash = wait.until { @driver.find_element(css: 'div#flash') }
    expect(flash.text.strip).to include('Your username is invalid!')

# Then('the email field should be invalid') do
#     email_field = @driver.find_element(name: 'username') # or 'email' depending on the page
#     is_valid = @driver.execute_script("return arguments[0].checkValidity();", email_field)
#     expect(is_valid).to be false
  end  
