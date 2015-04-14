Feature: Wishlist
  In order to keep track of courses they want to take
  A user
  Should be able to add/remove classes to/from their wishlist and view their wishlist

  Background:
    Given I have authenticated as some user

  Scenario: View wishlist
    Given I have the course EECS 293 in my wishlist
    When I visit /wishlist
    Then I should see EECS 293

  Scenario: Add course to wishlist via course show page
    Given
    When
    Then

  Scenario: Add course to wishlist via wishlist page
    Given
    When
    Then

  Scenario: Remove course from wishlist via course show page
    Given
    When
    Then

  Scenario: Remove course from wishlist via wishlist page
    Given
    When
    Then
