@security
Feature: Security and session handling
  As a ParaBank customer
  I want my session and my accounts to be protected
  So that nobody else can see or move my money

  @TC_SEC_01 @high @negative
  Scenario: Browser Back after logout does not show account data
    Given I am logged in as a new customer
    And I am on the "Accounts Overview" page
    When I click "Log Out"
    And I press the browser Back button
    Then I should not see any account data
    And I should be asked to log in

  @TC_SEC_02 @high @negative
  Scenario: A customer cannot view another customer's account
    Given another customer exists with account number "<other account>"
    And I am logged in as a new customer
    When I open "activity.htm?id=<other account>" directly
    Then I should not see that account's details or balance
    And I should see an access denied or "not found" message

  @TC_SEC_03 @high @negative
  Scenario: A customer cannot transfer money from another customer's account
    Given another customer exists with account number "<other account>"
    And I am logged in as a new customer
    When I send a transfer request with "<other account>" as the from account
    Then the transfer should be rejected
    And the other customer's balance should not change

  @TC_SEC_04 @medium @negative @needs_clarification
  Scenario Outline: An invalid account ID in the URL shows a clear error
    Given I am logged in as a new customer
    When I open "activity.htm?id=<id>" directly
    Then I should see the error "Could not find account # <id>"

    Examples:
      | case         | id       |
      | not existing | 99999999 |
      | not a number | abc      |

  @TC_SEC_05 @medium @negative
  Scenario: HTML entered in a name is shown as text, not rendered
    Given I am logged in as a new customer
    When I update my first name to "<b>Bold</b>"
    And I open "Accounts Overview"
    Then the left panel should show the literal text "<b>Bold</b>"
    And no bold formatting should be applied
