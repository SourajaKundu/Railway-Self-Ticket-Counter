# Railway-Self-Ticket-Counter
This project was inspired by my recent experience of buying tickets for JR (Japanese Railway) line trains with JPY coins. The Railway Ticket Counter project aims to design and implement a ticket vending machine for railway tickets. The system provides a user-friendly interface for customers to select their destinations and purchase tickets conveniently. It incorporates various features such as multiple destinations, varying ticket prices based on distance, and coin-based payment.

## Functionality
The ticket counter offers the following key functionalities:

# Destination Selection
The system provides a menu interface for customers to select their desired destination from the available options. In this project, there are four destinations to choose from.

# Ticket Pricing
Each destination has a different fixed price in increasing order based on the distance traveled. The system presents the ticket options to the customer and allows them to select the appropriate ticket based on their desired destination.

# Coin-based Payment
Customers can insert coins of denominations 50 and 100 JPY into the machine. The system keeps track of the amount inserted and displays the remaining amount required to purchase the selected ticket.

# Change Calculation
The system calculates the total ticket price and the amount of change to be returned to the customer if more money is inserted than required. It ensures accurate change calculation and provides the appropriate coins for change.

# LED Indication
To assist customers, the system includes LED indicators that light up to show the available destinations based on the amount of money inserted. This helps customers determine which destinations they can afford with their current payment.

# Handling corner cases in the testbench
1. Inserting an invalid coin (10 JPY): This tests how the vending machine handles an unsupported coin value.

2. Selecting a non-existing destination (10): This tests how the vending machine handles selecting a destination that does not exist.

3. Inserting exact change for the most expensive ticket (450 JPY): This tests if the vending machine correctly accepts the exact amount required for the ticket.

4. Inserting more than enough money for the ticket (550 JPY): This tests if the vending machine returns the appropriate change when the inserted amount exceeds the ticket price.
