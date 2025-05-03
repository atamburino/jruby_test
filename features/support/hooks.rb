# This file contains hooks that are executed before and after each scenario.
# Hooks are used to set up and tear down the test environment.

# Before hook to set up the Selenium WebDriver before each scenario.
Before do
  @driver = Selenium::WebDriver.for :chrome
end

# After hook to quit the Selenium WebDriver after each scenario.
After do
  @driver.quit
end
  