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

  @positive
  Scenario: Valid login with admin role
    When I open the login page
    And I enter "valid admin" credentials
    Then I should see the admin dashboard

  @positive
  Scenario: Valid login with user role
    When I open the login page
    And I enter "valid user" credentials
    Then I should see the user dashboard

  @positive
  Scenario: Password recovery
    When I open the login page
    And I click on the forgot password link
    And I enter my email address
    Then I should receive a password recovery email

  @negative
  Scenario: Account lockout after multiple failed attempts
    When I open the login page
    And I enter invalid credentials three times
    Then I should see an account lockout message

  @negative
  Scenario: Input validation for empty fields
    When I open the login page
    And I leave the username and password fields empty
    And I attempt to login
    Then I should see a validation error message

  @negative
  Scenario: Session timeout
    Given I am logged in as a "valid user"
    When I wait for the session to timeout
    Then I should be prompted to login again
