@accounts
Feature: Accounts
  As a logged-in customer
  I want to view my accounts and open new ones
  So that I can manage my money

  Background:
    Given I am logged in as a new customer

  @TC_ACC_01 @high @smoke
  Scenario: Accounts Overview lists my accounts
    When I open "Accounts Overview"
    Then I should see an accounts table with the columns:
      | Account          |
      | Balance*         |
      | Available Amount |
    And I should see exactly 1 account
    And I should see a "Total" row

  @TC_ACC_02 @medium
  Scenario: View account details
    When I open "Accounts Overview"
    And I click my account number
    Then I should see the "Account Details" for that account
    And the account type should be "CHECKING"
    And I should see its balance and available amount

  @TC_ACC_03 @low
  Scenario: Filter account activity by month and type
    Given my account has at least one transaction
    And I am on that account's activity page
    When I select the activity period "All"
    And I select the transaction type "Debit"
    And I click "Go"
    Then only debit transactions should be listed

  @TC_ACC_04 @TC_ACC_05 @high @smoke
  Scenario Outline: Open a new <type> account
    When I open "Open New Account"
    And I choose the account type "<type>"
    And I choose my existing account to fund it
    And I click "Open New Account"
    Then I should see the heading "Account Opened!"
    And I should see a new account number
    And the new account should appear in "Accounts Overview"
    And "Accounts Overview" should list 2 accounts

    Examples:
      | type     |
      | CHECKING |
      | SAVINGS  |

  @TC_ACC_06 @medium
  Scenario: The opening deposit is moved from the funding account
    Given my existing account has a balance of "$515.50"
    When I open a new "SAVINGS" account funded from my existing account
    Then my existing account balance should be "$415.50"
    And the new account balance should be "$100.00"
