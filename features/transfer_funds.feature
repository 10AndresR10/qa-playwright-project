@transfer
Feature: Transfer funds
  As a logged-in customer with more than one account
  I want to move money between my accounts
  So that each account has the funds I need

  Background:
    Given I am logged in as a new customer
    And I have two accounts "A" and "B"
    And I am on the "Transfer Funds" page

  @TC-TRF-01 @high @smoke
  Scenario: Transfer money between my accounts
    When I transfer "25" from account "A" to account "B"
    Then I should see the heading "Transfer Complete!"
    And I should see the message "$25.00 has been transferred from account #A to account #B."
    And account "A" balance should decrease by "$25.00"
    And account "B" balance should increase by "$25.00"

  @TC-TRF-02 @medium
  Scenario: A transfer appears in account activity
    Given I have transferred "25" from account "A" to account "B"
    When I open the activity of account "A"
    Then I should see a "Funds Transfer Sent" debit of "$25.00"

  @TC-TRF-03 @TC-TRF-04 @medium
  Scenario Outline: Invalid transfer amount is rejected
    When I transfer "<amount>" from account "A" to account "B"
    Then I should see a validation message for the amount

    Examples:
      | case        | amount |
      | empty       |        |
      | non-numeric | abc    |

  @TC-TRF-05 @high @edge
  Scenario Outline: Transfer above the available balance is rejected
    Given account "A" has a balance of "$415.50"
    When I transfer "<amount>" from account "A" to account "B"
    Then the transfer should be rejected for insufficient funds
    And account "A" balance should not change

    Examples:
      | case                  | amount |
      | one cent over balance | 415.51 |
      | far over balance      | 999999 |

  @TC-TRF-06 @low
  Scenario: Transfer to the same account is not allowed
    When I transfer "25" from account "A" to account "A"
    Then the transfer should be rejected

  # ---------- Negative and edge cases ----------

  @TC-TRF-07 @high @negative
  Scenario Outline: Invalid transfer amounts are rejected with a validation message
    When I transfer "<amount>" from account "A" to account "B"
    Then I should see a validation message for the amount
    And the balances of accounts "A" and "B" should not change

    Examples:
      | case                 | amount               |
      | zero                 | 0                    |
      | negative             | -10                  |
      | scientific notation  | 1e3                  |
      | thousands separator  | 1,000                |
      | currency symbol      | $10                  |
      | too many digits      | 99999999999999999999 |

  @TC-TRF-08 @high @edge
  Scenario: An amount with more than two decimals is handled correctly
    When I transfer "10.999" from account "A" to account "B"
    Then the amount should be rejected, or rounded to two decimals with the rounding shown to me
    And the balances in "Accounts Overview" should match the amount transferred

  @TC-TRF-09 @medium @edge
  Scenario Outline: Boundary amounts are transferred exactly
    Given account "A" has a balance of "$415.50"
    When I transfer "<amount>" from account "A" to account "B"
    Then I should see the heading "Transfer Complete!"
    And account "A" balance should be "<balance A after>"

    Examples:
      | case                     | amount  | balance A after |
      | smallest unit            | 0.01    | $415.49         |
      | surrounded by spaces     | " 10 "  | $405.50         |
      | exactly the full balance | 415.50  | $0.00           |

  @TC-TRF-10 @high @edge
  Scenario: Double-clicking Transfer sends the money only once
    When I enter "1" as the amount from account "A" to account "B"
    And I double-click "Transfer"
    Then account "A" balance should decrease by exactly "$1.00"
    And account "A" activity should show exactly one "Funds Transfer Sent" of "$1.00"
