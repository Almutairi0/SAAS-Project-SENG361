Feature: Order food from the menu
  As a student
  I want to add menu items to my cart without reloading the page and place my order
  So that I can pick up my food during my 15-minute break

  Scenario: Successful order
    Given I am logged in as a student
    And "Burger Corner" offers "Chicken Burger" for 15 SAR
    When I add "Chicken Burger" to my cart
    And I place my order
    Then my order should be confirmed with a total of 15 SAR

  Scenario: Ordering an item that is sold out
    Given I am logged in as a student
    And "Chicken Burger" from "Burger Corner" is sold out
    When I try to add "Chicken Burger" to my cart
    Then I should be told that "Chicken Burger" is sold out
    And my cart should be empty
