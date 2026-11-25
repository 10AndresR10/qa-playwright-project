@authentication
Feature: Login and logout
  As a ParaBank customer
  I want to log in and out of online banking
  So that only I can access my accounts

  Background:
    Given I am on the ParaBank home page

  @TC_LOGIN_01 @high @smoke
  Scenario: Login with valid credentials
    Given I am a registered customer named "Test User"
    When I log in with my username and password
    Then I should see the "Accounts Overview" page
    And the left panel should show "Welcome Test User"

  @TC_LOGIN_02 @TC_LOGIN_03 @TC_LOGIN_04 @medium
  Scenario Outline: Login is rejected with invalid credentials
    When I log in with username "<username>" and password "<password>"
    Then I should see the error "<error>"

    Examples:
      | case             | username         | password       | error                                             |
      | wrong password   | <registered>     | wrong_password | The username and password could not be verified. |
      | unknown username | no_such_user_xyz | any_password   | The username and password could not be verified. |
      | empty fields     |                  |                | Please enter a username and password.             |

  @TC_LOGIN_05 @high @smoke
  Scenario: Logout
    Given I am logged in as a new customer
    When I click "Log Out"
    Then I should see the login form
    And I should not see the "Log Out" link

  @TC_LOGIN_06 @medium
  Scenario: Account pages are not available after logout
    Given I am logged in as a new customer
    And I have logged out
    When I open the "overview.htm" page directly
    Then I should not see any account data
    And I should be asked to log in

  # ---------- Negative and edge cases ----------

  @TC_LOGIN_07 @medium @negative
  Scenario: Password is case-sensitive
    Given I am a registered customer with password "Passw0rd!"
    When I log in with my username and password "PASSW0RD!"
    Then I should see the error "The username and password could not be verified."

  @TC_LOGIN_08 @low @edge @needs_clarification
  Scenario: Password with an extra trailing space is rejected
    Given I am a registered customer with password "Passw0rd!"
    When I log in with my username and password "Passw0rd! "
    Then I should see the error "The username and password could not be verified."

  @TC_LOGIN_09 @low @edge
  Scenario: Username with leading and trailing spaces
    Given I am a registered customer
    When I log in with my username surrounded by spaces and my password
    Then I should see the "Accounts Overview" page
