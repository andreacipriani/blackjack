require 'rspec'
require_relative '../hand.rb'

describe Hand do
    let(:card1) { Card.new(:C, "A") }
    let(:card2) { Card.new(:D, "5") }
    let(:card3) { Card.new(:S, "K") }
    let(:card4) { Card.new(:S, "J") }
    let(:soft_hand) { Hand.new([card1, card2]) }
    let(:hand) { Hand.new([card2, card3]) }
  
    describe "#initialize" do
      it "initializes with a set of cards" do
        expect(hand.cards).to eq([card2, card3])
      end
    end
  
    describe "#add_card" do
      it "adds a card to the hand" do
        soft_hand.add_card(card3)
        expect(soft_hand.cards).to eq([card1, card2, card3])
      end
    end
  
    describe "#value" do
      context "when the hand contains an Ace" do
        it "calculates a soft total (Ace can be worth 1 or 11)" do
          expect(soft_hand.value).to eq([6, 16])
        end
      end
  
      context "when the hand does not contain an Ace" do
        it "calculates a hard total" do
          expect(hand.value).to eq(15)
        end
      end
    end
  
    describe "#highest_value" do
      it "returns the highest possible value of the hand" do
        expect(soft_hand.highest_value).to eq(16)
        expect(hand.highest_value).to eq(15)
      end
    end
  
    describe "#best_value" do
      context "when the hand has a soft total" do
        context "when the highest value is less than or equal to 21" do
          it "returns the highest value" do
            expect(soft_hand.best_value).to eq(16)
          end
        end
  
        context "when the highest value is greater than 21" do
          it "returns the lowest value" do
            card4 = Card.new(:S, "10")
            soft_hand.add_card(card4)
            expect(soft_hand.best_value).to eq(16)
          end
        end
      end
  
      context "when the hand has a hard total" do
        it "returns the value" do
          expect(hand.best_value).to eq(15)
        end
      end
    end
  
    describe "#lowest_value" do
      it "returns the lowest possible value of the hand" do
        expect(soft_hand.lowest_value).to eq(6)
      end
    end

    describe "#is_blackjack?" do
        context "when the hand contains 2 cards with a total value of 21" do
          it "returns true" do
            card1 = Card.new(:C, "A")
            card2 = Card.new(:D, "10")
                hand = Hand.new([card1, card2])
                expect(hand.is_blackjack?).to be true
              end
            end
        
            context "when the hand does not contain 2 cards with a total value of 21" do
              it "returns false" do
                expect(hand.is_blackjack?).to be false
              end
            end
          end
        
          describe "#is_bust?" do
            context "when the hand has a soft total and both values are greater than 21" do
              it "returns true" do
                card4 = Card.new(:S, "10")
                card5 = Card.new(:C, "6")
                soft_hand.add_card(card4)
                soft_hand.add_card(card5)
                expect(soft_hand.is_bust?).to be true
              end
            end
        
            context "when the hand has a hard total and the value is greater than 21" do
              it "returns true" do
                hand = Hand.new([card2, card3, card4])
                expect(hand.is_bust?).to be true
              end
            end
        
            context "when the hand has a total value less than or equal to 21" do
              it "returns false" do
                expect(hand.is_bust?).to be false
              end
            end
          end
        
          describe "#is_pair?" do
            context "when the hand contains 2 cards with the same value" do
              it "returns true" do
                card3 = Card.new(:S, "5")
                hand = Hand.new([card2, card3])
                expect(hand.is_pair?).to be true
              end
            end
        
            context "when the hand does not contain 2 cards with the same value" do
              it "returns false" do
                expect(hand.is_pair?).to be false
              end
            end
          end
        
          describe "#pair_highest_value" do
            context "when the hand is a pair" do
              it "returns the highest value of the pair" do
                card3 = Card.new(:S, "5")
                hand = Hand.new([card2, card3])
                expect(hand.pair_highest_value).to eq(5)
              end
            end
        
            context "when the hand is not a pair" do
              it "raises an error" do
                expect { hand.pair_highest_value }.to raise_error("pair_highest_value can only be called on pairs")
              end
            end
          end
        
          describe "#size" do
            it "returns the number of cards in the hand" do
              expect(hand.size).to eq(2)
            end
          end
        
          describe "#to_s" do
            context "when the hand is a blackjack" do
              it "returns a string representation of the hand with Blackjack!" do
                card1 = Card.new(:D, "J")
                card2 = Card.new(:D, "A")
                hand = Hand.new([card1, card2])
                expect(hand.to_s).to eq("J♦, A♦ = Blackjack!")
              end
            end
        
            context "when the hand is a bust" do
              it "returns a string representation of the hand with Busted!" do
                card1 = Card.new(:D, "10")
                card2 = Card.new(:C, "K")
                card3 = Card.new(:D, "2")
                hand = Hand.new([card1, card2, card3])
                expect(hand.to_s).to eq("10♦, K♣, 2♦ = Busted!")
              end
            end
        
            context "when the hand has a normal value" do
              it "returns a string representation of the hand with the value" do
                expect(hand.to_s).to eq("5♦, K♠ = 15")
              end
            end
          end
        end