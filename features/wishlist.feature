Feature: Wishlist
  In order to keep track of courses they want to take
  A user
  Should be able to add/remove classes to/from their wishlist and view their wishlist and toggle notifications

  Background:
    Given I have authenticated as some user
    And The course EECS 293 exists

  Scenario: View wishlist
    Given I have the course EECS 293 in my wishlist
    When I visit "/wishlist"
    Then I should see "EECS 293"

  Scenario: Add course to wishlist via course show page
    Given I do not have the course EECS 293 in my wishlist
    When I visit "/courses/EECS293"
    Then I should see "Add to my wishlist"
    When I click the link "Add to my wishlist"
    Then I should have the course EECS 293 in my wishlist
    And  I should see "Remove from my wishlist"

  Scenario: Add course to wishlist via wishlist page
    Given I do not have the course EECS 293 in my wishlist
    When I visit "/wishlist"
    Then I should not see "EECS 293"
    When I fill in "course_title" with "EECS293"
    And I click the hidden button "#submit"
    Then I should have the course EECS 293 in my wishlist
    And I should see "Remove from my wishlist"

  Scenario: Remove course from wishlist via course show page
    Given I have the course EECS 293 in my wishlist
    When I visit "/courses/EECS293"
    Then I should see "Remove from my wishlist"
    When I click the link "Remove from my wishlist"
    Then I should not have the course EECS 293 in my wishlist
    And I should see "Add to my wishlist"

  Scenario: Remove course from wishlist via wishlist page
    Given My wishlist is empty
    And I have the course EECS 293 in my wishlist
    When I visit "/wishlist"
    Then I should see "EECS 293"
    And I should see "Remove from my wishlist"
    When I click the link "Remove from my wishlist"
    Then I should not have the course EECS 293 in my wishlist
    And I should not see "EECS 293"

  Scenario: Turn on notifications for a course
    Given My wishlist is empty
    And I have the course EECS 293 in my wishlist
    And I do not have notifications turned on for EECS 293
    When I visit "/wishlist"
    Then I should see "Turn on notifications"
    When I click the link "Turn on notifications"
    Then I should have notifications turned on for EECS 293
    And I should see "Turn off notifications"

  Scenario: Turn off notifications for a course
    Given My wishlist is empty
    And I have the course EECS 293 in my wishlist
    And I have notifications turned on for EECS 293
    When I visit "/wishlist"
    Then I should see "Turn off notifications"
    When I click the link "Turn off notifications"
    Then I should have notifications turned off for EECS 293
    And I should see "Turn on notifications"

  Scenario: User has multiple classes in wishlist
    Given My wishlist is empty
    And I have the course EECS 293 in my wishlist
    And The course EECS 233 exists
    And I have the course EECS 233 in my wishlist
    And I have notifications turned on for EECS 293
    When I visit "/wishlist"
    And I click the link "Turn off notifications"
    Then EECS 233 is the first class in my wishlist
