#!/usr/bin/env ruby
require_relative 'cards.rb'
require_relative 'hand.rb'
require_relative 'strategy.rb'
require_relative 'rules.rb'

##
# A simple Monte Carlo simulation on Blackjack
# to evaluate different strategies.
##

class Game
    def initialize
        @sabot = Sabot.new
        @stack = 100
        @rules = EuropeanRules.new
        @n_hands = 100
        @hand_status = :not_started
    end
    
    def play
        puts "Shuffling sabot"
        @sabot.shuffle
        hand_counter = 1
        @n_hands.times do
            @hand_status = :in_progress
            play_hand(hand_counter)
            hand_counter += 1
        end
    end
    
    private
    def play_hand(hand_counter)
        player_bet = 10
        puts "Hand ##{hand_counter}"
        puts "\tPlayer bets #{player_bet}$"
    
        player_cards = []
        dealer_cards = []
        player_cards << @sabot.draw
        dealer_cards << @sabot.draw
        player_cards << @sabot.draw

        is_first_move = true

        player_hand = Hand.new(player_cards)
        puts "\tPlayer has: #{player_hand}"
        dealer_hand = Hand.new(dealer_cards)
        puts "\tDealer has: #{dealer_hand}"

        # Check for dealer blackjack
        if dealer_hand.is_blackjack?
            if player_hand.is_blackjack?
                finish_hand(player_bet, :double_blackjack)
            else
                finish_hand(player_bet, :dealer_blackjack)
            end
        end

        # Check for player blackjack
        if player_hand.is_blackjack?
            finish_hand(player_bet, :blackjack)
        end
            
        # Check for insurance

        # Check for double

        # Check for split
        while @hand_status != :completed
            if !is_first_move
                player_hand = Hand.new(player_cards)
                puts "\tPlayer has: #{player_hand}"
            end
            is_first_move = false

            if player_hand.is_bust?
                finish_hand(player_bet, :bust)
                break
            end
            
            player_action = BasicStrategy.recommendation(player_hand, dealer_cards.first)
            if player_action == "hit"
                new_card = @sabot.draw
                puts "\tPlayer hits #{new_card}"
                player_cards << new_card
            elsif player_action == "stand"
                puts "\tPlayer stands"
                # Dealer plays
                while @hand_status != :completed
                    dealer_new_card = @sabot.draw
                    puts "\tDealer hits #{dealer_new_card}"
                    dealer_cards << dealer_new_card 
                    puts "\tDealer has: #{dealer_hand}"
                    if dealer_hand.is_bust?
                        finish_hand(player_bet, :dealer_bust)
                    elsif dealer_hand.highest_value.between?(17,21) || dealer_hand.lowest_value.between?(17,21)
                        if dealer_hand.highest_value > player_hand.highest_value
                            finish_hand(player_bet, :lose)
                        elsif dealer_hand.highest_value == player_hand.highest_value
                            finish_hand(player_bet, :draw)
                        else
                            finish_hand(player_bet, :win)
                        end
                    else
                        # hands continue to be played
                    end
                end
            else
                raise "Unknown player action #{player_action}"
            end 
        end
    end

    def finish_hand(player_bet, hand_result)
        if hand_result == :blackjack
            puts "\tBlackjack! Player wins."
        elsif hand_result == :win
            puts "\tPlayer wins!"
        elsif hand_result == :draw
            puts "\tIt's a draw!"
        elsif hand_result == :double_blackjack
            puts "\tBoth player and dealer have a Blackjack, it's a draw!"
        elsif hand_result == :bust
            puts "\tPlayer busted. Dealer wins!"
        elsif hand_result == :dealer_bust
            puts "\tDealer busted. Player wins!"
        elsif hand_result == :dealer_blackjack
            puts "\tBlackjack! Dealer wins."
        elsif hand_result == :lose
            puts "\tDealer wins!"
        else
            raise("unknown hand_result #{hand_result}")
        end
        update_stack(player_bet, hand_result)
        @hand_status = :completed
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
