@loan
Feature: Request a loan
  As a logged-in customer
  I want to apply for a loan
  So that I can borrow money when I need it

  Background:
    Given I am logged in as a new customer
    And I am on the "Request Loan" page

  @TC_LOAN_01 @high @smoke
  Scenario: Loan is approved
    When I apply for a loan of "100" with a down payment of "10" from my account
    Then I should see the heading "Loan Request Processed"
    And the loan provider should be "Wealth Securities Dynamic Loans (WSDL)"
    And the loan status should be "Approved"
    And I should see the message "Congratulations, your loan has been approved."
    And I should see a new account number
    And the new loan account should appear in "Accounts Overview"

  @TC_LOAN_02 @medium
  Scenario: Loan is denied when funds are insufficient
    When I apply for a loan of "1000000" with a down payment of "10" from my account
    Then the loan status should be "Denied"
    And I should see the message "We cannot grant a loan in that amount with your available funds."

  @TC_LOAN_03 @low
  Scenario: Applying with empty fields shows validation errors
    When I click "Apply Now" without entering any amounts
    Then I should see validation messages for the loan amount and down payment

  # ---------- Negative and edge cases ----------

  @TC_LOAN_04 @medium @negative
  Scenario Outline: Non-numeric loan values show a validation message
    When I apply for a loan of "<amount>" with a down payment of "<down payment>" from my account
    Then I should see a validation message for the <invalid field>

    Examples:
      | amount | down payment | invalid field |
      | abc    | 10           | loan amount   |
      | 100    | abc          | down payment  |

  @TC_LOAN_05 @medium @negative @needs_clarification
  Scenario Outline: Zero or negative loan values are rejected as invalid input
    When I apply for a loan of "<amount>" with a down payment of "<down payment>" from my account
    Then I should see a validation message that the value must be greater than zero
    And no loan account should be created

    Examples:
      | case                  | amount | down payment |
      | zero amount           | 0      | 0            |
      | negative amount       | -100   | 10           |
      | negative down payment | 100    | -10          |

  @TC_LOAN_06 @medium @edge @needs_clarification
  Scenario: Down payment larger than the account balance is denied
    Given my account balance is "$515.50"
    When I apply for a loan of "1000" with a down payment of "600" from my account
    Then the loan status should be "Denied"
    And I should see the message "You do not have sufficient funds for the given down payment."
