Feature: Login page

  Scenario: Login page
    Given I am not logged in
    When I am on the "login" page
    Then I should see "Manage your spectacular team"
