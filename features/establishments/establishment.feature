Feature: Establishment
  In order to create an establishment
  A signed in user
  Should be able to manage establishments


  Scenario: User creates an establishment
    Given I am logged in
      And I visit new establishment page
      And I fill in form with new establishment
     Then I should see the establishment
