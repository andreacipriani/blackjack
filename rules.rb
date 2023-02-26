class EuropeanRules
    def can_double(hand)
        if hand.cards.size != 2 || hand.has_ace?
            return false
        end
        return hand.highest_value.between?(8,11)
    end
end
