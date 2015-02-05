Feature: Create check-in Ballyhoo
	Ballyhoo's are only assigned to a valid establishment, and are not dependent on existing Challenges
	Check-in's can apply to the patron or the patron and friends.
	If friends are included, the number of friends are selected
	Check-in's only run for the day, but can be set to repeat

	Background:
    Given I am logged in as an owner of the establishment "Fat Joes"

	Scenario: Create Simple Check-in Ballyhoo successfully
		Given there are no Check-in Ballyhoos
		 And I'm on the new Check-in Ballyhoo page
		When I fill in "Point Value" with "10"
			And I select "April 16, 2014" as the ballyhoo "valid on" date
			And I select 
