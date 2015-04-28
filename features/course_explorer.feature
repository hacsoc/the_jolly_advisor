Feature: Explorer
  In order to find courses quickly
  A user
  Should be able to search for classes with multiple parameters

  Background:
    Given I have authenticated as some user
    And I have 30 courses to search
    And I visit "/courses"

  Scenario: Search by professor
    When I search for a professor
    Then I only see courses taught by that professor

  Scenario: Search by Course ID
    When I search for a course by course department and number
    Then I only see that course in the list

  Scenario: Search by Department
    When I search for a department
    Then I only see classes from that department
    And the courses are in ascending order

  Scenario: Search by keyword in a course description
    When I search for courses by a keyword
    Then I see only classes with that keyword in the name

  Scenario: Page through classes
    Given An unsearched list of courses
    Then I can page through courses

  Scenario: I can navigate to Course Show page
    When I select a class on the Course Explorer Page
    Then I am taken to the show page of that class