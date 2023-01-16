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
        @cards.shuffle!
        puts "Sabot built with #{@n_decks} decks and a total of #{@cards.size} cards"
    end
end
