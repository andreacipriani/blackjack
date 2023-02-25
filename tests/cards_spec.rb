require 'rspec'
require_relative '../cards.rb'

describe Card do
  let(:card) { Card.new(:C, "A") }

  describe "#initialize" do
    it "initializes with a suit and a value" do
      expect(card.suit).to eq(:C)
      expect(card.value).to eq("A")
    end
  end

  describe "#bj_value" do
    context "when card is a face card" do
      it "returns 10" do
        face_card = Card.new(:H, "K")
        expect(face_card.bj_value).to eq(10)
      end
    end

    context "when card is an Ace" do
      it "returns [1, 11]" do
        expect(card.bj_value).to eq([1, 11])
      end
    end

    context "when card is a number card" do
      it "returns the integer value of the card" do
        number_card = Card.new(:D, "5")
        expect(number_card.bj_value).to eq(5)
      end
    end
  end

  describe "#bj_highest_value" do
    context "when card is a face card" do
      it "returns 10" do
        face_card = Card.new(:H, "K")
        expect(face_card.bj_highest_value).to eq(10)
      end
    end

    context "when card is an Ace" do
      it "returns 11" do
        expect(card.bj_highest_value).to eq(11)
      end
    end

    context "when card is a number card" do
      it "returns the integer value of the card" do
        number_card = Card.new(:D, "5")
        expect(number_card.bj_highest_value).to eq(5)
      end
    end
  end

  describe "#is_ace?" do
    context "when card is an Ace" do
      it "returns true" do
        expect(card.is_ace?).to be true
      end
    end

    context "when card is not an Ace" do
      it "returns false" do
        number_card = Card.new(:D, "5")
        expect(number_card.is_ace?).to be false
      end
    end
  end

  describe "#to_s" do
    it "returns a string representation of the card" do
      expect(card.to_s).to eq("A♣")
    end
  end
end

describe Deck do
  let(:deck) { Deck.new }

  describe "#initialize" do
    it "initializes with 52 cards" do
      expect(deck.cards.size).to eq(52)
    end
  end

  describe "#to_s" do
    it "returns a string representation of the deck" do
      expect(deck.to_s).to be_a(String)
    end
  end
end

describe Sabot do
    let(:sabot) { Sabot.new(6) }
  
    describe "#initialize" do
      it "initializes with the given number of decks" do
        expect(sabot.cards.size).to eq(6 * 52)
      end
    end
  
    describe "#draw" do
      context "when there are cards in the sabot" do
        it "removes and returns the top card" do
          top_card = sabot.cards.last
          expect(sabot.draw).to eq(top_card)
          expect(sabot.cards.size).to eq(6 * 52 - 1)
        end
      end
  
      context "when there are no cards in the sabot" do
        it "adds expected number of decks" do
          (6 * 52).times { sabot.draw }
          expect(sabot.cards.size).to eq(0)
          sabot.draw # no more cards
          expect(sabot.cards.size).to eq(6 * 52 - 1)
        end

        it "shuffles new cards" do
          # assumes that if the first 13 cards are of the same suit, the deck isn't shuffled
          first_card = sabot.draw
          are_same_suit = true
          12.times { 
            card = sabot.draw
            if (card.suit != first_card.suit)
              are_same_suit = false
            end
          }
          expect(are_same_suit).to be false
        end

        it "resets current cards count" do
          (6 * 52).times { sabot.draw }
          expect(sabot.current_count).to eq(0)
        end
      end
    end
  
    describe "#to_s" do
      it "returns a string representation of the sabot" do
        expect(sabot.to_s).to be_a(String)
      end
    end
  end