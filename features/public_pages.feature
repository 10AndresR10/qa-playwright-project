@public
Feature: Public pages
  As a visitor who is not logged in
  I want to read about the bank and contact customer care
  So that I can get information and help

  @TC-PUB-01 @low
  Scenario: Submitting an empty contact form shows required-field errors
    Given I am on the "Customer Care" page
    When I click "Send to Customer Care"
    Then I should see these field errors:
      | Name is required.    |
      | Email is required.   |
      | Phone is required.   |
      | Message is required. |

  @TC-PUB-02 @low
  Scenario: Send a message to customer care
    Given I am on the "Customer Care" page
    When I fill in my name "Test", a valid email, phone and a message
    And I click "Send to Customer Care"
    Then I should see the heading "Customer Care"
    And I should see the message "Thank you Test"
    And I should see the message "A Customer Care Representative will be contacting you."

  @TC-PUB-03 @low
  Scenario: About Us page
    Given I am on the ParaBank home page
    When I click "About Us"
    Then the page title should be "ParaBank | About Us"
    And I should see the text "ParaBank is a demo site used for demonstration of Parasoft software solutions."

  # ---------- Negative and edge cases ----------

  @TC-PUB-04 @low @negative
  Scenario Outline: Contact form rejects invalid contact details
    Given I am on the "Customer Care" page
    When I fill in the contact form with a valid name and message
    But I set the <field> to "<value>"
    And I click "Send to Customer Care"
    Then I should see a field error for the <field>
    And the message should not be sent

    Examples:
      | field | value        |
      | email | not-an-email |
      | phone | abc          |
