Feature: Tips and Reviews
  In order to help other students plan their courses
  A user
  Should be able to leave reviews and tips on courses and vote on others' tips

  Scenario: Create a review
    Given I have authenticated as some user
    And The course EECS 293 exists
    And The course EECS 293 has 0 reviews
    When I visit "/courses/EECS293"
    Then I should see "Tips and Reviews"
    When I select a professor from the dropdown
    And I fill in "review_body" with some text
    And I click the button "Create Review"
    Then I should see that review
    And That review should have helpfulness 0

  Scenario: Upvote a review
    Given I have authenticated as some user
    And The course EECS 293 has a review with helpfulness 3
    When I visit "/courses/EECS293"
    And I click the upvote button for that review
    Then That review should have helpfulness 4

  Scenario: Downvote a review
    Given I have authenticated as some user
    And The course EECS 293 has a review with helpfulness 2
    When I visit "/courses/EECS293"
    And I click the downvote button for that review
    Then That review should have helpfulness 1

  Scenario: Reading reviews
    Given The course EECS 293 has 10 reviews
    When I visit "/courses/EECS293"
    Then I should see "Tips and Reviews"
    And I should see 10 reviews
    And The reviews should be ordered by helpfulness
