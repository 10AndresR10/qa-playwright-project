@find_transactions
Feature: Find transactions
  As a logged-in customer
  I want to search my transactions
  So that I can locate a specific payment or transfer

  Background:
    Given I am logged in as a new customer
    And I have two accounts "A" and "B"
    And I have transferred "25" from account "A" to account "B" today
    And I am on the "Find Transactions" page
    And I have selected account "A"

  @TC_FIND_01 @medium
  Scenario: Find transactions by amount
    When I search by amount "25"
    Then I should see the heading "Transaction Results"
    And I should see a "Funds Transfer Sent" transaction of "$25.00"

  @TC_FIND_02 @medium
  Scenario: Find transactions by date
    When I search by date "<today in MM-DD-YYYY>"
    Then I should see today's transactions

  @TC_FIND_03 @low
  Scenario: Find transactions by date range
    When I search between "<today in MM-DD-YYYY>" and "<today in MM-DD-YYYY>"
    Then I should see today's transactions

  @TC_FIND_04 @low
  Scenario: Find a transaction by its ID
    Given I know the ID of the transfer from the account activity page
    When I search by transaction ID
    Then I should see exactly that transaction

  @TC_FIND_05 @low
  Scenario: Searching with an empty amount
    When I search by amount ""
    Then I should see the error "Invalid amount"

  # ---------- Negative and edge cases ----------

  @TC_FIND_06 @medium @negative @needs_clarification
  Scenario Outline: Invalid search input shows an error
    When I search by <search type> with "<value>"
    Then I should see the error "<error>"

    Examples:
      | search type    | value      | error                  |
      | date           | 2026-11-23 | Invalid date format    |
      | date           |            | Invalid date format    |
      | transaction ID | abc        | Invalid transaction ID |
      | transaction ID |            | Invalid transaction ID |
      | amount         | abc        | Invalid amount         |

  @TC_FIND_07 @low @edge
  Scenario Outline: Impossible search values are rejected
    When I search by <search type> with "<value>"
    Then I should see an error explaining the value is invalid

    Examples:
      | case                     | search type | value      |
      | date that does not exist | date        | 02-30-2026 |
      | negative amount          | amount      | -1         |

  @TC_FIND_08 @low @edge
  Scenario Outline: A search with no matches shows an empty result
    When I search by <search type> with "<value>"
    Then I should see the heading "Transaction Results"
    And no transactions should be listed

    Examples:
      | search type    | value      |
      | amount         | 12345      |
      | transaction ID | 99999999   |
      | date           | 12-31-2030 |

  @TC_FIND_09 @low @negative @needs_clarification
  Scenario: Searching by date range with empty dates shows an error
    When I search between "" and ""
    Then I should see the error "Invalid date format"

  @TC_FIND_10 @low @edge
  Scenario: A date range whose start is after its end is rejected
    When I search between "12-31-2026" and "01-01-2026"
    Then I should see an error explaining the date range is invalid
