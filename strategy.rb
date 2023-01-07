class BasicStrategy   
    def self.recommendation(hand, dealer_card)
        # If the hand has an Ace, it is a soft total
        if hand.has_ace?
            self.soft_recommendation(hand, dealer_card)
        else
            self.hard_recommendation(hand, dealer_card)
        end
    end

    private

    # TODO:  implement from https://www.blackjackapprenticeship.com/blackjack-strategy-charts/
    def self.soft_recommendation(hand, dealer_card)
        "hit"
    end

    def self.hard_recommendation(hand, dealer_card)
        case hand.value
        when 8 then "hit"
        when 9 then
            if dealer_card.is_ace?
                "hit"
            elsif dealer_card.bj_value.between?(3,6)
                "hit" #"double"
            else
                "hit"   
            end
        when 12 then
            "stand"
        when 18 then
            "stand"
        else 
            "hit"
        end
    end
end
