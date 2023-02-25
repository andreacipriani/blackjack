A Montecarlo simulation for evaluating Blackjack strategies.

- Implements Blackjack [Basic Strategy](https://en.wikipedia.org/wiki/Blackjack#Basic_strategy)


Example output:

```
Hand #1. Card count is: 0
	Player bets 10$
	Player has: 6D, 3S = 9
	Dealer has: 3C
	Player doubles! Player hits 8H and has: 6D, 3S, 8H = 17.
	Dealer hits 9D
	Dealer has: 3C, 9D = 12
	Dealer hits 10D
	Dealer has: 3C, 9D, 10D = Busted!
	Dealer busted. Player wins!
	Player stack is now 120$
Hand #2. Card count is: 2
	Player bets 10$
	Player has: 7S, 8H = 15
	Dealer has: KC
	Player hits 5C and has: 7S, 8H, 5C = 20
	Player stands
	Dealer hits JD
	Dealer has: KC, JD = 20
	It's a draw!
	Player stack is now 120$
Hand #3. Card count is: 1
	Player bets 10$
	Player has: 8D, 5S = 13
	Dealer has: 2S
	Player stands
	Dealer hits 8S
	Dealer has: 2S, 8S = 10
	Dealer hits 5H
	Dealer has: 2S, 8S, 5H = 15
	Dealer hits 10S
	Dealer has: 2S, 8S, 5H, 10S = Busted!
	Dealer busted. Player wins!
	Player stack is now 130$
```
