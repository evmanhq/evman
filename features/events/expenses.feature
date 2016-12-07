Feature: Expenses page of event
  Background: login user with all permissions
    Given I am logged in as user with all permissions
    And Example event exists and observed
    And I am on the "event expenses" page

  Scenario: Adding expense to event
    When I submit add expense form
    Then I should see a new expense

  Scenario: Adding warehouse item to event
    When I submit add warehouse item form
    Then I should see a new warehouse item transaction in event
