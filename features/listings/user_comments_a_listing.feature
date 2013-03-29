Feature: User comments a listing
  In order to take part into discussion about a listing
  As a person who is viewing the listing
  I want to be able to comment the listing

  @javascript
  @fix_for_new_design
  Scenario: Adding a new comment successfully
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
    And there is favor request with title "Massage" from "kassi_testperson1"
    And I am logged in as "kassi_testperson2"
    When I follow "Massage"
    #And I should see "Follow this listing"
    And I should not see "Stop following this listing"
    And I fill in "comment_content" with "Test comment"
    And I press "Send comment"
    And I should see "Test comment" within "#comments"
    And the system processes jobs
    And I should not see "Follow this listing"
    #And I should see "Stop following this listing"
    When I log out
    And I log in as "kassi_testperson1"
    Then I should see "1" within "#notifications_link"
    When I follow "notifications_link"
    Then I should see "has commented on your request"
    When I follow "your request"
    And I fill in "comment_content" with "Test answer"
    And I press "Send comment"
    And the system processes jobs
    When I log out
    And I log in as "kassi_testperson2"
    And the system processes jobs
    And I go to the home page
    Then I should see "1" within "#notifications_link"
    When I follow "notifications_link"
    Then I should see "has commented on a request you follow"
    When I follow "a request you follow"
    And I fill in "comment_content" with "Test comment 2"
    And I uncheck "comment_author_follow_status"
    And I press "Send comment"
    #Then I should see "Follow this listing"
    And I should not see "Stop following this listing"
    #When I follow "Follow this listing"
    #Then I should see "You are now following this listing"
    When I log out
    And I log in as "kassi_testperson1"
    And I follow "Massage"
    And I fill in "comment_content" with "Test answer 2"
    And I press "Send comment"
    When I click ".user-menu-toggle"
    And I follow "Logout"
    And I log in as "kassi_testperson2"
    And the system processes jobs
    Then I should not see "1" within "#notifications_link"
  
  @javascript
  Scenario: Trying to add a new comment without content
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
    And there is favor request with title "Massage" from "kassi_testperson1"
    And I am logged in as "kassi_testperson2"
    When I follow "Massage"
    And I press "Send comment"
    Then I should see "This field is required."
      
  Scenario: Trying to add a comment without logging in
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
    And there is favor request with title "Massage" from "kassi_testperson1"
    And I am not logged in
    And I am on the home page
    When I follow "Massage"
    Then I should see "You must log in to send a new comment."
    And I should not see "Write a new comment:"
    
  Scenario: Users get email from followed listing
    Given there are following users:
      | person | email | given_name | family_name |
      | kassi_testperson1 | t1@example.com | John | MacTest |
      | kassi_testperson2 | t2@example.com | Anthony | Debugger |
    And there is favor request with title "Walking dogs" from "kassi_testperson1"
    And I am logged in as "kassi_testperson2"
    When I follow "Walking dogs"
    Then I should see "Notify me of new comments and updates"
    When I fill in "comment_content" with "Test comment 1"
    And I press "Send comment"
    And the system processes jobs
    Then I should see "Test comment 1" within "#comments"
    And "t1@example.com" should receive an email with subject "Anthony Debugger has commented on your listing in Sharetribe"
    And "t2@example.com" should have no emails
    
    When I log out
    And I log in as "kassi_testperson1"
    When "t1@example.com" opens the email
    And I follow "en/listings" in the email
    Then I should see "Walking dogs"
    And I should see "Test comment 1" within "#comments"
    When I fill in "comment_content" with "Test comment 2"
    And I press "Send comment"
    And the system processes jobs
    Then I should see "Test comment 2" within "#comments"
    And "t2@example.com" should receive an email with subject "John MacTest has commented on a listing you follow in Sharetribe"
    
    When "t2@example.com" opens the email
    And I follow "en/listings" in the email
    Then I should see "Walking dogs"
    And I should see "Test comment 1" within "#comments"
    And I should see "Test comment 2" within "#comments"
  
  