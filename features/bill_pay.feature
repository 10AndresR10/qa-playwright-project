@bill-pay
Feature: Bill pay
  As a logged-in customer
  I want to pay bills to a payee from my account
  So that I can settle my bills online

  Background:
    Given I am logged in as a new customer
    And I am on the "Bill Pay" page

  @TC-BILL-01 @high @smoke
  Scenario: Pay a bill
    When I enter the payee details:
      | Payee Name       | Electric Co |
      | Address          | 2 Power St  |
      | City             | Springfield |
      | State            | CA          |
      | Zip Code         | 90001       |
      | Phone #          | 5550000     |
      | Account #        | 12345       |
      | Verify Account # | 12345       |
      | Amount           | 10          |
    And I click "Send Payment"
    Then I should see the heading "Bill Payment Complete"
    And I should see the message "Bill Payment to Electric Co in the amount of $10.00 from account <my account> was successful."

  @TC-BILL-02 @medium
  Scenario: Submitting an empty form shows required-field errors
    When I click "Send Payment"
    Then I should see these field errors:
      | Payee name is required.     |
      | Address is required.        |
      | City is required.           |
      | State is required.          |
      | Zip Code is required.       |
      | Phone number is required.   |
      | Account number is required. |
      | Account number is required. |
      | The amount cannot be empty. |

  @TC-BILL-03 @medium
  Scenario: Account number verification does not match
    When I fill in valid payee details
    But I enter "12345" as the account number and "54321" as the verify account number
    And I click "Send Payment"
    Then I should see the field error "The account numbers do not match."

  @TC-BILL-04 @medium
  Scenario: Amount is not a number
    When I fill in valid payee details
    But I enter "abc" as the amount
    And I click "Send Payment"
    Then I should see the field error "Please enter a valid amount."

  @TC-BILL-05 @medium
  Scenario: Paying a bill reduces the account balance
    Given my account balance is "$515.50"
    When I pay a bill of "10" from my account
    And I open "Accounts Overview"
    Then my account balance should be "$505.50"

  # ---------- Negative and edge cases ----------

  @TC-BILL-06 @high @negative
  Scenario Outline: Invalid payment amounts are rejected
    Given my account balance is "$515.50"
    When I fill in valid payee details
    But I enter "<amount>" as the amount
    And I click "Send Payment"
    Then the payment should be rejected with a message about the amount
    And my account balance should not change

    Examples:
      | case               | amount   |
      | zero               | 0        |
      | negative           | -10      |
      | above the balance  | 99999999 |

  @TC-BILL-07 @medium @negative
  Scenario: Payee account number must be numeric
    When I fill in valid payee details
    But I enter "abc" as the account number and "abc" as the verify account number
    And I click "Send Payment"
    Then I should see the field error "Please enter a valid number." for both account number fields

  @TC-BILL-08 @low @edge
  Scenario: The smallest amount can be paid
    When I pay a bill of "0.01" from my account
    Then I should see the message "Bill Payment to Electric Co in the amount of $0.01 from account <my account> was successful."
