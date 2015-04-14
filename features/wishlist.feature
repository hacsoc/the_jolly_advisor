Feature: Wishlist
  In order to keep track of courses they want to take
  A user
  Should be able to add/remove classes to/from their wishlist and view their wishlist

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
    Given
    When
    Then

  Scenario: Remove course from wishlist via course show page
    Given I have the course EECS 293 in my wishlist
    When I visit "/courses/EECS293"
    Then I should see "Remove from my wishlist"
    When I click the link "Remove from my wishlist"
    Then I should not have the course EECS 293 in my wishlist
    And I should see "Add to my wishlist"

  Scenario: Remove course from wishlist via wishlist page
    Given
    When
    Then
