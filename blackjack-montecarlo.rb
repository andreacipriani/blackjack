#!/usr/bin/env ruby
require_relative 'cards.rb'
require_relative 'hand.rb'
require_relative 'strategy.rb'
require_relative 'rules.rb'

##
# A simple Monte Carlo simulation on Blackjack
# to evaluate different strategies.
##

# TODOs:
# - move player bet as part of strategy: low - medium - max

class Game
    def initialize(rules = EuropeanRules.new)
        @sabot = Sabot.new
        @stack = 100
        @rules = rules
        @strategy = BasicStrategy.new(rules)
        @n_hands = 100
    end
    
    def play
        hand_counter = 1
        @n_hands.times do
            play_hand(hand_counter)
            hand_counter += 1
        end
    end
    
    private
    def play_hand(hand_counter)
        player_bet = 10
        seat = 1
        puts "Hand ##{hand_counter}. Card count is: #{@sabot.current_count}"
        puts "\t#{player(seat)} bets #{player_bet}$"
    
        player_hand = Hand.new([@sabot.draw])
        dealer_hand = Hand.new([@sabot.draw])
        player_hand.add_card(@sabot.draw)
        puts "\t#{player(seat)} has: #{player_hand}"
        puts "\tDealer has: #{dealer_hand}"
        dealer_second_card = @sabot.draw # Dealer's second card is hidden

        if check_for_blackjacks(seat, player_hand, dealer_hand, dealer_second_card, player_bet)
            return
        end

        action = play_seat(seat, player_hand, dealer_hand, dealer_second_card, player_bet)
        if action == :stand
            play_dealer(player_hand, dealer_hand, dealer_second_card, player_bet)
        end
        should_evaluate = action != :split
        if should_evaluate
            evaluate_seat(seat, player_hand, dealer_hand, player_bet)
        end
    end

    def player(seat, multiple_seats = false)
        if multiple_seats
            "Player on seat #{seat}"
        else
            "Player"
        end
    end

    def play_seat(
        seat,
        player_hand,
        dealer_hand,
        dealer_second_card,
        player_bet,
        multiple_seats = false
    ) 
        # Player's turn
        finished_playing = false
        while !finished_playing
            if player_hand.is_bust?
                finished_playing = true
                return :bust
            end
            player_action = @strategy.recommendation(player_hand, dealer_hand.cards.first)
            if player_action == :double
                new_card = @sabot.draw
                player_hand.add_card(new_card)
                player_bet *= 2
                puts "\t#{player(seat, multiple_seats)} doubles! Player hits #{new_card} and has: #{player_hand}."
            elsif player_action == :hit
                new_card = @sabot.draw
                player_hand.add_card(new_card)
                puts "\t#{player(seat, multiple_seats)} hits #{new_card} and has: #{player_hand}"
            elsif player_action == :split
                puts "\t#{player(seat, multiple_seats)} splits!"
                play_split_seat(seat, player_hand, dealer_hand, dealer_second_card, player_bet)
                return :split
            elsif player_action == :stand
                puts "\t#{player(seat, multiple_seats)} stands"
                finished_playing = true
                return :stand
            else
                raise "Unknown player action #{player_action}"
            end 
        end
        return :playing
    end

    def play_dealer(
        player_hand,
        dealer_hand,
        dealer_second_card,
        player_bet
    )
        puts "\tDealer's turn"
        has_used_second_card = false
        while (dealer_hand.best_value.between?(17,21) || dealer_hand.is_bust?) == false
            dealer_new_card = has_used_second_card ? dealer_second_card : @sabot.draw
            has_used_second_card = true
            dealer_hand.add_card(dealer_new_card)
            puts "\tDealer hits #{dealer_new_card} and has: #{dealer_hand}"
        end
    end

    def check_for_blackjacks(seat, player_hand, dealer_hand, dealer_second_card, player_bet)
        # Check for dealer blackjack
        dealer_hand_with_second_card = Hand.new([dealer_hand.cards.first, dealer_second_card])
        if dealer_hand_with_second_card.is_blackjack?
            if player_hand.is_blackjack?
                puts("\tDealer reveals card #{dealer_second_card}")
                finish_seat(seat, player_bet, :double_blackjack)
                return true
            else
                puts("\tDealer reveals card #{dealer_second_card}")
                finish_seat(seat, player_bet, :dealer_blackjack)
                return true
            end
        end

        # Check for player blackjack
        if player_hand.is_blackjack?
            finish_seat(seat, player_bet, :blackjack)
            return true
        end
        return false
    end

    def play_split_seat(
        seat,
        player_hand,
        dealer_hand,
        dealer_second_card,
        player_bet
    )
        first_seat_hand = Hand.new([player_hand.cards[0]])
        second_seat_hand = Hand.new([player_hand.cards[1]])

        first_action = play_seat(seat, first_seat_hand, dealer_hand, dealer_second_card, player_bet, true)    
        second_action = play_seat(seat + 1, second_seat_hand, dealer_hand, dealer_second_card, player_bet, true)
        
        if first_action == :stand ||second_action == :stand
            play_dealer(second_seat_hand, dealer_hand, dealer_second_card, player_bet)
        end
        evaluate_seat(seat, first_seat_hand, dealer_hand, player_bet, true)
        evaluate_seat(seat + 1, second_seat_hand, dealer_hand, player_bet, true)
    end

    def evaluate_seat(
        seat,
        seat_hand, 
        dealer_hand,
        player_bet,
        multiple_seats = false
    )
        if seat_hand.is_bust?
            finish_seat(seat, player_bet, :bust, multiple_seats)
            return
        end
        if dealer_hand.is_bust?
            finish_seat(seat, player_bet, :dealer_bust, multiple_seats)
            return
        else
            if dealer_hand.highest_value > seat_hand.best_value
                finish_seat(seat, player_bet, :lose, multiple_seats)
            elsif dealer_hand.highest_value == seat_hand.best_value
                finish_seat(seat, player_bet, :draw, multiple_seats)
            else
                finish_seat(seat, player_bet, :win, multiple_seats)
            end
        end
    end

    def finish_seat(
        seat,
        player_bet,
        hand_result,
        multiple_seats = false
    )
        if hand_result == :blackjack
            puts "\tBlackjack! #{player(seat, multiple_seats)} wins."
        elsif hand_result == :win
            puts "\t#{player(seat, multiple_seats)} wins!"
        elsif hand_result == :draw
            puts "\t#{player(seat, multiple_seats)} has a draw!"
        elsif hand_result == :double_blackjack
            puts "\tBoth #{player(multiple_seats)} and dealer have a Blackjack, it's a draw!"
        elsif hand_result == :bust
            puts "\t#{player(seat, multiple_seats)} busted. Dealer wins!"
        elsif hand_result == :dealer_bust
            puts "\tDealer busted. #{player(multiple_seats)} wins!"
        elsif hand_result == :dealer_blackjack
            puts "\tBlackjack! Dealer wins against #{player(seat, multiple_seats)}"
        elsif hand_result == :lose
            puts "\tDealer wins against #{player(seat, multiple_seats)}."
        else
            raise("unknown hand_result #{hand_result}")
        end
        update_stack(player_bet, hand_result)
    end
    
    def update_stack(player_bet, hand_result)
        if hand_result == :blackjack
            @stack += (player_bet * 1.5)
        elsif hand_result == :win || hand_result == :dealer_bust
            @stack += player_bet
        elsif hand_result == :draw || hand_result == :double_blackjack
            # No change to stack
        elsif hand_result == :lose || hand_result == :dealer_blackjack || hand_result == :bust
            @stack -= player_bet
        else
            raise("unknown hand_result #{hand_result}")
        end
        puts "\tPlayer stack is now #{@stack}$"
    end
end

puts "Running Blackjack Monte Carlo Simulation"
game = Game.new
game.play
