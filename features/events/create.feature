Feature: Creation of the Event
  Background: login user with all permissions
    Given I am logged in as user with all permissions

  Scenario: Open new event form from main menu
    When I am on the "events" page
    Then I should see "Create event"
    When I click on "Create event"
    Then I should see events form

  Scenario: Create new event using form
    When Event associations are bootstraped
    And I am on the "new events" page
    And I fill event form
    And I submit event form
    Then Event should be saved