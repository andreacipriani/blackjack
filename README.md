A Montecarlo simulation for evaluating Blackjack strategies.

- Implements Blackjack [Basic Strategy](https://en.wikipedia.org/wiki/Blackjack#Basic_strategy)


Example output:

```
Hand #1. Card count is: 0
	Player bets 10$
	Player has: J♥, 6♠ = 16
	Dealer has: 6♥
	Player stands
	Dealer hits 7♣
	Dealer has: 6♥, 7♣ = 13
	Dealer hits 8♦
	Dealer has: 6♥, 7♣, 8♦ = 21
	Dealer wins!
	Player stack is now 90$
Hand #2. Card count is: 1
	Player bets 10$
	Player has: 4♣, J♠ = 14
	Dealer has: 2♥
	Player stands
	Dealer hits 3♠
	Dealer has: 2♥, 3♠ = 5
	Dealer hits 10♠
	Dealer has: 2♥, 3♠, 10♠ = 15
	Dealer hits A♦
	Dealer has: 2♥, 3♠, 10♠, A♦ = [16, 26]
	Dealer hits 8♣
	Dealer has: 2♥, 3♠, 10♠, A♦, 8♣ = Busted!
	Dealer busted. Player wins!
	Player stack is now 100$
...
```
