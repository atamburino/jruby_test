Feature: Login Feature Test

  @positive
  Scenario: Validate test setup
    When I open the login page
    Then I should see the correct page title

  @negative
  Scenario: Invalid login
    When I open the login page
    When I enter invalid credentials
    Then I should see an error message
