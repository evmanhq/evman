Feature: Show page of event
  Background: login user with all permissions
    Given I am logged in as user with all permissions
    And Example event exists and observed
    And I am on the "event" page

  Scenario: Show action should print event status
    When Focused on ".event-flags"
    Then I should see approved status
    And I should see committed status
    And I should see archived status

  Scenario: Map modal
    When I click on address button
    Then I should see "Event location"

  Scenario: Adding note to event
    When I submit new note form
    Then I should see last note content

  Scenario: Adding attendee to event
    When I submit add attendee form
    Then I should see new attendee

  Scenario: Adding talk to event
    When I submit new event talk form
    Then I should see new talk in the event
