Feature: User updates profile information
  In order to change the information the other users see in my profile page
  As a user
  I want to able to update my profile information

  @javascript
  Scenario: Updating profile successfully
    Given there are following users:
      | person | 
      | kassi_testperson2 |
    And I am logged in as "kassi_testperson2"
    When I follow "Settings"
    And I fill in "Given name:" with "Test"
    And I fill in "Family name:" with "Dude"
    And I fill in "Location:" with "Broadway"
    And wait for 2 seconds
    # These features removed with google map functionality
    #And I fill in "Postal code" with "11111"
    #And I fill in "City" with "Turku"
    And I fill in "Phone number" with "0700-715517"
    And I fill in "About you:" with "Some random text about me"
    And I press "Save information"
    Then I should see "Information updated" within "#notifications"
    And the "Given name:" field should contain "Test"
    And the "Family name:" field should contain "Dude"
    And the "Location:" field should contain "Broadway"
  
  @javascript
  Scenario: Trying to update profile with false information
    Given there are following users:
      | person | 
      | kassi_testperson2 |
    And I am logged in as "kassi_testperson2"
    When I follow "Settings"
    And I fill in "Given name:" with ""
    And I fill in "Family name:" with ""
    And I fill in "About you:" with "Some random text"
    And I press "Save information"
    Then I should see "This field is required." within ".error"
    When given name and last name are not required in community "test"
    When I follow "Settings"
    And I fill in "Given name:" with ""
    And I fill in "Family name:" with ""
    And I fill in "About you:" with "Some random text"
    And I press "Save information"
    Then I should see "Information updated" within "#notifications"
    And the "Given name:" field should contain ""
    And the "Family name:" field should contain ""
    And the "About you" field should contain "Some random text"

