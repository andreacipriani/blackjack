A Montecarlo simulation for evaluating Blackjack strategies.

- Implements Blackjack [Basic Strategy](https://en.wikipedia.org/wiki/Blackjack#Basic_strategy)


Example output:

```
Running Blackjack Monte Carlo Simulation
Sabot built with 6 decks and a total of 312 cards
Hand #1. Card count is: 0
	Player bets 10$
	Player has: 8♣, 10♠ = 18
	Dealer has: K♣
	Player stands
	Dealer's turn
	Dealer hits 2♦ and has: K♣, 2♦ = 12
	Dealer hits 7♠ and has: K♣, 2♦, 7♠ = 19
	Dealer wins against Player.
	Player stack is now 90$
Hand #2. Card count is: -1
	Player bets 10$
	Player has: 5♥, A♦ = [6, 16]
	Dealer has: 10♠
	Player hits 6♥ and has: 5♥, A♦, 6♥ = [12, 22]
	Player hits Q♠ and has: 5♥, A♦, 6♥, Q♠ = Busted!
	Player busted. Dealer wins!
	Player stack is now 80$
Hand #3. Card count is: -2
	Player bets 10$
	Player has: 9♥, J♥ = 19
	Dealer has: 7♣
	Player stands
	Dealer's turn
	Dealer hits K♥ and has: 7♣, K♥ = 17
	Player wins!
	Player stack is now 90$
Hand #4. Card count is: -3
	Player bets 10$
	Player has: 10♥, 5♦ = 15
	Dealer has: J♣
	Player hits 4♦ and has: 10♥, 5♦, 4♦ = 19
	Player stands
	Dealer's turn
	Dealer hits 2♣ and has: J♣, 2♣ = 12
	Dealer hits 6♦ and has: J♣, 2♣, 6♦ = 18
	Player wins!
	Player stack is now 100$
Hand #5. Card count is: -1
	Player bets 10$
	Player has: K♠, 6♦ = 16
	Dealer has: 9♠
	Player hits 3♦ and has: K♠, 6♦, 3♦ = 19
	Player stands
	Dealer's turn
	Dealer hits 3♦ and has: 9♠, 3♦ = 12
	Dealer hits Q♦ and has: 9♠, 3♦, Q♦ = Busted!
	Dealer busted. Player wins!
	Player stack is now 110$
Hand #6. Card count is: 0
	Player bets 10$
	Player has: 4♣, 2♦ = 6
	Dealer has: 4♥
	Player hits 6♠ and has: 4♣, 2♦, 6♠ = 12
	Player stands
	Dealer's turn
	Dealer hits A♥ and has: 4♥, A♥ = [5, 15]
	Dealer hits 10♥ and has: 4♥, A♥, 10♥ = [15, 25]
	Dealer hits 10♥ and has: 4♥, A♥, 10♥, 10♥ = Busted!
	Dealer busted. Player wins!
	Player stack is now 120$
Hand #7. Card count is: 2
	Player bets 10$
	Player has: 2♣, 4♠ = 6
	Dealer has: 5♥
	Player hits 8♦ and has: 2♣, 4♠, 8♦ = 14
	Player stands
	Dealer's turn
	Dealer hits Q♦ and has: 5♥, Q♦ = 15
	Dealer hits 10♣ and has: 5♥, Q♦, 10♣ = Busted!
	Dealer busted. Player wins!
	Player stack is now 130$
Hand #8. Card count is: 3
	Player bets 10$
	Player has: 2♥, A♥ = [3, 13]
	Dealer has: K♣
	Player hits 3♥ and has: 2♥, A♥, 3♥ = [6, 16]
	Player hits 2♠ and has: 2♥, A♥, 3♥, 2♠ = [8, 18]
	Player hits 4♣ and has: 2♥, A♥, 3♥, 2♠, 4♣ = [12, 22]
	Player hits 4♣ and has: 2♥, A♥, 3♥, 2♠, 4♣, 4♣ = [16, 26]
	Player hits 5♣ and has: 2♥, A♥, 3♥, 2♠, 4♣, 4♣, 5♣ = [21, 31]
	Player stands
	Dealer's turn
	Dealer hits 6♠ and has: K♣, 6♠ = 16
	Dealer hits 7♠ and has: K♣, 6♠, 7♠ = Busted!
	Dealer busted. Player wins!
	Player stack is now 140$
Hand #9. Card count is: 8
	Player bets 10$
	Player has: 3♦, 8♥ = 11
	Dealer has: 4♠
	Player doubles! Player hits K♥ and has: 3♦, 8♥, K♥ = 21.
	Player stands
	Dealer's turn
	Dealer hits 2♦ and has: 4♠, 2♦ = 6
	Dealer hits 8♥ and has: 4♠, 2♦, 8♥ = 14
	Dealer hits 8♥ and has: 4♠, 2♦, 8♥, 8♥ = Busted!
	Dealer busted. Player wins!
	Player stack is now 150$
Hand #10. Card count is: 10
	Player bets 10$
	Player has: K♦, A♦ = Blackjack!
	Dealer has: 6♦
	Blackjack! Player wins.
	Player stack is now 165.0$
```
