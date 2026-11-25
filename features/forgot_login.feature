@forgot_login
Feature: Forgot login info
  As a customer who forgot my credentials
  I want to recover my username and password with my personal details
  So that I can access online banking again

  Background:
    Given I am on the ParaBank home page
    And I click "Forgot login info?"

  @TC_LOOKUP_01 @medium
  Scenario: Submitting an empty lookup form shows required-field errors
    When I click "Find My Login Info"
    Then I should see these field errors:
      | First name is required.             |
      | Last name is required.              |
      | Address is required.                |
      | City is required.                   |
      | State is required.                  |
      | Zip Code is required.               |
      | Social Security Number is required. |

  @TC_LOOKUP_02 @medium
  Scenario: Recover login info of an existing customer
    Given a customer is registered with a unique SSN
    When I enter that customer's name, address and SSN
    And I click "Find My Login Info"
    Then I should see the customer's username and password

  @TC_LOOKUP_03 @low
  Scenario: Lookup for a customer that does not exist
    When I enter personal details that match no customer
    And I click "Find My Login Info"
    Then I should see the error "The customer information provided could not be found."
