@registration
Feature: Customer registration
  As a new visitor
  I want to register for online banking
  So that I can open and manage bank accounts

  Background:
    Given I am on the ParaBank registration page

  @TC_REG_01 @high @smoke
  Scenario: Register a new customer
    When I fill in the registration form with valid data and a unique username
    And I click "Register"
    Then I should see the heading "Welcome <my username>"
    And I should see the message "Your account was created successfully. You are now logged in."
    And I should see the "Log Out" link

  @TC_REG_02 @medium
  Scenario: Submitting an empty form shows required-field errors
    When I click "Register"
    Then I should see these field errors:
      | First name is required.             |
      | Last name is required.              |
      | Address is required.                |
      | City is required.                   |
      | State is required.                  |
      | Zip Code is required.               |
      | Social Security Number is required. |
      | Username is required.               |
      | Password is required.               |
      | Password confirmation is required.  |

  @TC_REG_03 @medium
  Scenario: Password confirmation does not match
    When I fill in the registration form with valid data
    But I enter "Different1!" as the password confirmation
    And I click "Register"
    Then I should see the field error "Passwords did not match."

  @TC_REG_04 @medium
  Scenario: Username is already taken
    Given a customer is already registered with username "<existing>"
    When I fill in the registration form using the username "<existing>"
    And I click "Register"
    Then I should see the field error "This username already exists."

  @TC_REG_05 @low
  Scenario: Phone number is optional
    When I fill in the registration form with valid data
    But I leave the phone number empty
    And I click "Register"
    Then I should see the message "Your account was created successfully. You are now logged in."

  @TC_REG_06 @medium
  Scenario: A new customer starts with one funded checking account
    When I register a new customer
    And I open "Accounts Overview"
    Then I should see exactly 1 account
    And the account balance should be "$515.50"

  # ---------- Negative and edge cases ----------

  @TC_REG_07 @medium @negative
  Scenario Outline: Invalid registration input is rejected
    When I fill in the registration form with valid data
    But I set the <field> to "<value>"
    And I click "Register"
    Then the registration should be rejected
    And I should see a field error for the <field>

    Examples:
      | case                   | field    | value                   |
      | username only spaces   | username | <4 spaces>              |
      | one-character password | password | a                       |
      | 255-character username | username | <255 random characters> |

  @TC_REG_08 @low @edge @needs_clarification
  Scenario: Usernames that differ only in letter case are treated as the same user
    Given a customer is already registered with username "QaUser<unique>"
    When I fill in the registration form using the username "qauser<unique>"
    And I click "Register"
    Then I should see the field error "This username already exists."

  @TC_REG_09 @low @edge
  Scenario: Leading and trailing spaces are removed from the username
    When I fill in the registration form with valid data
    But I set the username to "  user<unique>  "
    And I click "Register"
    Then I should see the heading "Welcome user<unique>"

  @TC_REG_10 @medium @edge
  Scenario: Names with accented characters are accepted
    When I fill in the registration form with valid data
    But I set the first name to "José" and the last name to "Ñúñez"
    And I click "Register"
    Then I should see the message "Your account was created successfully. You are now logged in."
    And the left panel should show "Welcome José Ñúñez"
