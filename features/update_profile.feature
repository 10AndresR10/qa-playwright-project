@profile
Feature: Update contact info
  As a logged-in customer
  I want to update my address and phone number
  So that the bank has my current contact details

  Background:
    Given I am logged in as a new customer
    And I am on the "Update Contact Info" page

  @TC-PROF-01 @medium
  Scenario: The form shows my current details
    Then the form should be pre-filled with my registration details

  @TC-PROF-02 @high
  Scenario: Update my city
    When I change the city to "Newtown"
    And I click "Update Profile"
    Then I should see the heading "Profile Updated"
    And I should see the message "Your updated address and phone number have been added to the system."
    And when I reopen "Update Contact Info" the city should be "Newtown"

  @TC-PROF-03 @medium
  Scenario: A required field cannot be cleared
    When I clear the first name
    And I click "Update Profile"
    Then I should see the field error "First name is required."

  # ---------- Negative and edge cases ----------

  @TC-PROF-04 @medium @negative
  Scenario Outline: Invalid contact details are rejected
    When I set the <field> to "<value>"
    And I click "Update Profile"
    Then I should see a field error for the <field>
    And my saved <field> should not change

    Examples:
      | case               | field      | value       |
      | spaces only        | first name | "   "       |
      | letters in zip     | zip code   | ABCDE       |
      | letters in phone   | phone      | not-a-phone |

  @TC-PROF-05 @low @edge
  Scenario: Accented characters are saved correctly
    When I set the first name to "José"
    And I click "Update Profile"
    Then I should see the heading "Profile Updated"
    And when I reopen "Update Contact Info" the first name should be "José"
