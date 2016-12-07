Feature: Creation of the Event
  Background: login user with all permissions
    Given I am logged in as user with all permissions
    And Example event exists and observed

  Scenario: Open edit event modal from main menu
    When I am on the "event" page
    Then I should see "Edit"
    When I click on "Edit"
    Then I should see edit event modal

  Scenario: Update event using form
    When Event associations are bootstraped
    And I am on the "edit event" page
    And I fill event form
    And I submit event form
    Then Event should be updated