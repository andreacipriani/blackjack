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
        has_ace? ? soft_total_value : hard_total_value
    end

    def has_ace?
        @cards.any? { |card| card.is_ace? }
    end

    def highest_value
        value.is_a?(Array) ? value.max : value
    end

    def lowest_value
        value.is_a?(Array) ? value.min : value
    end
    
    def is_blackjack?
        highest_value == 21 && @cards.size == 2
    end

    def is_bust?
        if value.is_a?(Array)
            value[0] > 21 && value[1] > 21
        else
            value > 21
        end
    end

    def to_s
        if @cards.size == 1
            "#{@cards[0]}"
        elsif is_blackjack?
            "#{@cards.join(", ")} = Blackjack!"
        else
            "#{@cards.join(", ")} = #{value}"
        end
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
                total[0] += card.bj_value
                total[1] += card.bj_value
            end
        end
        total
    end

    def hard_total_value
        total = 0
        @cards.each do |card|
            total += card.bj_value
        end
        total
    end
end