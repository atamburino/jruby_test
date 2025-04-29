require 'selenium-webdriver'


Given('I have launched the browser') do
    @driver = Selenium::WebDriver.for :chrome
end

When('I open the login page') do
    @driver.navigate.to "https://the-internet.herokuapp.com/login"
end

Then('I should see the correct page title') do
    expect(@driver.title).to include("The Internet")
    @driver.quit
end

