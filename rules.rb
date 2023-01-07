class EuropeanRules
    def can_double(hand)
        # Players can double when the sum of the first two cards
        # is a value between 8 and 11
        if (hand.cards.size != 2 || hand.has_ace?)
            false
        end
        hand.highest_value.between?(8,11)
    end

    # min bet

    # max bet
end
