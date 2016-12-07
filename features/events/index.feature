Feature: Index page
  Background: login user with all permissions
    Given I am logged in as user with all permissions

  Scenario: Committed event
    When "Committed" event exists in current team
    And I am on the "events" page
    And Focused on "committed-events" panel
    Then I should see it

  Scenario: Committed event I am attending
    When "Committed" event exists in current team
    And I am attending that event
    And I am on the "events" page
    And Focused on "committed-events" panel
    Then I should see it
    And it should be written in bold

  Scenario: Tracked event
    When "Normal" event exists in current team
    And I am on the "events" page
    And Focused on "tracked-events" panel
    Then I should see it

  Scenario: Approved event
    When "Approved" event exists in current team
    And I am on the "events" page
    And Focused on "tracked-events" panel
    Then I should see it
    And it should be written in bold

  Scenario: CFP deadline event
    When "CFP Deadline Future" event exists in current team
    And I am on the "events" page
    And Focused on "cfp-deadline-events" panel
    Then I should see it

  Scenario: Event in continent pannel
    When "Normal" event exists in current team
    And I am on the "events" page
    And focused on it's continent panel
    Then I should see it
