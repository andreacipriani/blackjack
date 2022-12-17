#!/usr/bin/env ruby

##
# A simple Monte Carlo simulation on Blackjack
# to evaluate different strategies.
##

class Card
    attr_reader :suit, :value
    def initialize(suit, value)
        @suit = suit
        @value = value
    end
    
    def value
        return 10 if ["J", "Q", "K"].include?(@value)
        return [1,11] if is_ace?
        return @value.to_i
    end

    def is_ace?
        @value == "A"
    end
    
    def to_s
        "#{@value}#{suit}"
    end
end	

class Deck
    attr_reader :cards
    
    def initialize
        @cards = []
        [:C, :D, :S, :H].each do |suit|
            ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].each do |value|
                @cards << Card.new(suit, value)
            end
        end
    end

    def to_s
        @cards.join(", ")
    end
end

class Hand 
    attr_reader :cards
    
    def initialize(cards)
        @cards = cards
    end

    def add_card(card)
        @cards << card
    end

    def value
        # If the hand contains an Ace, calculate a soft total (Ace can be worth 1 or 11)
        # otherwise calculate a hard total
        @cards.any? { |card| card.is_ace? } ? soft_total_value : hard_total_value
    end

    def highest_value
        if value.is_a?(Array)
            value.max
        else
            value
        end
    end
    
    def is_bust?
        if value.is_a?(Array)
            value[0] > 21 && value[1] > 21
        else
            value > 21
        end
    end

    def to_s
        "#{@cards.join("+ ")} = #{value}"
    end

    private
    def soft_total_value
        has_seen_ace = false
        total = [0,0] # First element with Ace as 1, second element with Ace as 11

        @cards.each do |card|
            if (card.is_ace? && !has_seen_ace)
                total[0] += 1
                total[1] += 11
                has_seen_ace = true
            elsif (card.is_ace? && has_seen_ace) # Multiple Aces can't be worth 11
                total[0] += 1
                total[1] += 1
            else
                total[0] += card.value
                total[1] += card.value
            end
        end
        total
    end

    def hard_total_value
        total = 0
        @cards.each do |card|
            total += card.value
        end
        total
    end
end

class Sabot
    attr_reader :cards

    def initialize(n_decks = 6)
        @n_decks = n_decks
        @cards = []
        build_sabot
    end

    def draw
        if @cards.empty?
            puts "No more cards in the Sabot, adding decks and shuffling..."
            build_sabot
            @cards.pop
        else
            @cards.pop
        end
    end
    
    def shuffle
        @cards.shuffle!
    end

    def to_s
        @cards.join(", ")
    end

    private
    def build_sabot
        @cards = []
        @n_decks.times do
            deck = Deck.new
            @cards += deck.cards
        end
        puts "Sabot built with #{@n_decks} decks and a total of #{@cards.size} cards"
    end
end

class BasicStrategy
    HARD_TOTALS = {
        4 => "hit",
        5 => "hit",
        6 => "hit",
        7 => "hit",
        8 => "hit",
        9 => "hit",
        10 => "hit",
        11 => "hit",
        12 => "hit",
        13 => "stand",
        14 => "stand",
        15 => "stand",
        16 => "stand",
        17 => "stand",
        18 => "stand",
        19 => "stand",
        20 => "stand",
        21 => "stand"
      }
      SOFT_TOTALS = {
        12 => "hit",
        13 => "hit",
        14 => "hit",
        15 => "hit",
        16 => "hit",
        17 => "hit",
        18 => "stand",
        19 => "stand",
        20 => "stand",
        21 => "stand"
      }
    
      def self.recommendation(hand, dealer_card)
        # Check if the hand contains an Ace
        has_ace = hand.any? { |card| card.value == "A" }
    
        # Calculate the total value of the hand
        total = calculate_hand(hand)
    
        if has_ace
          # If the hand has an Ace, it is a soft total
          return SOFT_TOTALS[total]
        else
          # If the hand does not have an Ace, it is a hard total
          return HARD_TOTALS[total]
        end
      end
    
      private

      def self.calculate_hand(hand)
        values = hand.map { |card| card.value }
        total = 0
        values.each do |value|
          if value.is_a?(Array)
            # If the value is an array, it means the card is an Ace and can be worth either 1 or 11
            if (total + 11) > 21
                total += 1
            else
              total += 11
            end
          else
            total += value
          end
        end
        total
    end
end

class Game
    def initialize
        @sabot = Sabot.new
        @stack = 100
    end
    
    def play
        puts "Shuffling sabot"
        @sabot.shuffle
        hand_counter = 1
        10000.times do
            hand_counter += 1
            play_hand(hand_counter)
        end
    end
    
    private
    def play_hand(hand_counter)
        player_bet = 10
        puts "New hand: ##{hand_counter}. Player bets #{player_bet}$"
    
        player_cards = []
        dealer_cards = []
        player_cards << @sabot.draw
        dealer_cards << @sabot.draw
        player_cards << @sabot.draw

        hand_is_complete = false
        
        is_first_move = true

        player_hand = Hand.new(player_cards)
        puts "\tPlayer has: #{player_cards.join(" ")} = #{player_hand.value}"
        puts "\tDealer has: #{dealer_cards.join(" ")}"

        while !hand_is_complete
            if !is_first_move
                player_hand = Hand.new(player_cards)
                puts "\tPlayer has: #{player_cards.join(" ")} = #{player_hand.value}"
            end
            is_first_move = false

            if player_hand.is_bust?
                puts "\tPlayer busted"
                update_stack(player_bet, :bust)
                hand_is_complete = true
                break
            end

            # Check for blackjack
            # Check for insurance
            # Check for double
            # Check for split
            
            player_action = BasicStrategy.recommendation(player_cards, dealer_cards.first)
            if player_action == "hit"
                puts "\tPlayer hits"
                player_cards << @sabot.draw
            elsif player_action == "stand"
                puts "\tPlayer stands"
                # Dealer plays
                while true
                    dealer_cards << @sabot.draw
                    puts "\tDealer hits"
                    dealer_hand = Hand.new(dealer_cards)
                    puts "\tDealer has: #{dealer_cards.join(" ")} = #{dealer_hand.value}"
                    if dealer_hand.is_bust?
                        puts "\tDealer busted"
                        update_stack(player_bet, :win)
                        hand_is_complete = true
                        break
                    elsif dealer_hand.highest_value >= 17
                        if dealer_hand.highest_value > player_hand.highest_value
                            puts "\tDealer wins"
                            update_stack(player_bet, :lose)
                        elsif dealer_hand.highest_value == player_hand.highest_value
                            puts "\tIt's a draw"
                            update_stack(player_bet, :draw)
                        else
                            puts "\tPlayer wins"
                            update_stack(player_bet, :win)
                        end
                        hand_is_complete = true
                        break
                    else
                        # hands continue to be played
                    end
                end
            else
                raise "Unknown player action #{player_action}"
            end 
        end
    end
    
    def update_stack(player_bet, hand_result)
        if hand_result == :win
            @stack += player_bet
        elsif hand_result == :draw
            # No change to stack
        else
            @stack -= player_bet
        end
        puts "\tPlayer stack is now #{@stack}$"
    end
end

puts "Running Blackjack Monte Carlo Simulation"
game = Game.new
game.play
