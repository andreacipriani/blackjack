class Card
    attr_reader :suit, :value
    def initialize(suit, value)
        @suit = suit
        @value = value
    end
    
    def bj_value
        return 10 if ["J", "Q", "K"].include?(@value)
        return [1,11] if is_ace?
        return @value.to_i
    end
    
    def bj_highest_value
        return 10 if ["J", "Q", "K"].include?(@value)
        return 11 if is_ace?
        return @value.to_i
    end

    def is_ace?
        @value == "A"
    end
    
    def to_s
        "#{@value}#{symbol(suit)}"
    end

    private
    def symbol(suit)
        case suit
            when :D then "♦"
            when :S then "♠"
            when :C then "♣"
            when :H then "♥"
        end
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

class Sabot
    attr_reader :cards, :current_count

    def initialize(n_decks = 6)
        @n_decks = n_decks
        @cards = []
        @current_count = 0
        build_sabot
    end

    def draw
        if @cards.empty?
            puts "No more cards in the Sabot, adding decks and shuffling..."
            build_sabot
        end
        card = @cards.pop
        update_count(card)
        return card
    end

    def to_s
        "Sabot initialized with #{@n_decks.size} decks, has #{@cards.size} cards left"
    end

    private
    def update_count(card)
        if card.bj_highest_value > 9
            @current_count -= 1
        elsif card.bj_highest_value < 7
            @current_count += 1
        end
    end

    def build_sabot
        @cards = []
        @n_decks.times do
            deck = Deck.new
            @cards += deck.cards
        end
        @cards.shuffle!
        @current_count = 0
        puts "Sabot built with #{@n_decks} decks and a total of #{@cards.size} cards"
    end
end
