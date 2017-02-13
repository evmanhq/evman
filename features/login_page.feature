Feature: Login page

  Scenario: Login page
    Given I am not logged in
    When I am on the "login" page
    Then I should see "Manage your spectacular team"

  Scenario: Register user using oauth
    Given Oauth mock is set:
      | uid | provider | name      | email           |
      | 1   | github   | John Test | john@github.com |
    And I am not logged in
    And I am on the "login" page
    When I click on "Github"
    Then I should be logged in as new user
    And Current user should have emails:
      | email           |
      | john@github.com |
    And Current user should have identities:
      | uid | provider |
      | 1   | github   |

  Scenario: Login user using oauth
    Given Oauth mock is set:
      | uid | provider | name      | email           |
      | 1   | github   | John Test | john@github.com |
    And User with identity exists:
      | uid | provider | name      | email           |
      | 1   | github   | John Test | john@github.com |
    And I am not logged in
    And I am on the "login" page
    When I click on "Github"
    Then I should be logged in as existing user

  Scenario: Register new identity
    Given Oauth mock is set:
      | uid | provider | name      | email             |
      | 1   | facebook | John Test | john@facebook.com |
    And User with identity exists and logged in:
      | uid | provider | name      | email           |
      | 1   | github   | John Test | john@github.com |
    And I am on the "profile" page
    When I click on "Facebook"
    Then Current user should have emails:
      | email             |
      | john@github.com   |
      | john@facebook.com |
    And Current user should have identities:
      | uid | provider |
      | 1   | facebook |
      | 1   | github   |

  Scenario: Autojoin Team by domain
    Given Oauth mock is set:
      | uid | provider | name      | email           |
      | 1   | github   | John Test | john@redhat.com |
    And Team with email domain "redhat.com" exists
    And I am on the "login" page
    When I click on "Github"
    Then I should be logged in as new user
    And I should be in a team

  Scenario: Refuse login without invitation

    In case the application is configured to require invitation

    Given Evman requires invitation
    And Oauth mock is set:
      | uid | provider | name      | email           |
      | 1   | github   | John Test | john@redhat.com |
    And I am on the "login" page
    When I click on "Github"
    Then I should not be logged in

  Scenario: Accept login with invitation

    In case the application is configured to require invitation

    Given Evman requires invitation
    And Invitation exists
    And Oauth mock is set:
      | uid | provider | name      | email           |
      | 1   | github   | John Test | john@github.com |
    And I am on the "invitation" page
    When I click on "Github"
    Then I should be logged in as new user
    And I should be in a team