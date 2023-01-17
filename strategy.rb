class BasicStrategy   
    def self.recommendation(hand, dealer_card)
        # If hand is a Pair, evaluate differently considering split
        if hand.is_pair?
            return self.pair_recommendation(hand, dealer_card)
        end
        # If the hand has an Ace, it is a soft total
        if hand.has_ace?
            self.soft_recommendation(hand, dealer_card)
        else
            self.hard_recommendation(hand, dealer_card)
        end
    end

    private

    def self.pair_recommendation(hand, dealer_card)
        case hand.pair_highest_value
        when 11 then :split
        when 10 then :stand
        when 9 then 
            if [7, 10, 11].include?(dealer_card.bj_highest_value)
                :stand
            else
                :split
            end
        when 8 then
            :split
        when 7 then
            if (8..11).include?(dealer_card.bj_highest_value)
                :hit
            else
                :split
            end
        when 6 then
            if (7..11).include?(dealer_card.bj_highest_value)
                return :hit
            else
                return :split
            end
        when 5 then
            if [10, 11].include?(dealer_card.bj_highest_value)
                :hit
            else
                :double
            end
        when 4 then
            if [5, 6].include?(dealer_card.bj_highest_value)
                :split
            else
                :hit
            end
        else
            if (8..11).include?(dealer_card.bj_highest_value)
                :hit
            else
                :split
            end 
        end
    end

    def self.hard_recommendation(hand, dealer_card)
        case hand.value
        when 17..21 then
            :stand
        when 13..16 then
            if (2..6).include?(dealer_card.bj_highest_value)
                :stand
            else
                :hit
            end
        when 12 then
            if (4..6).include?(dealer_card.bj_highest_value)
                :stand
            else
                :hit
            end
        when 11 then
            double_fallback_hit(hand)
        when 10 then
            if (10..11).include?(dealer_card.bj_highest_value)
                :hit
            else
                self.double_fallback_hit(hand)
            end
        when 9 then
            if (3..6).include?(dealer_card.bj_highest_value)
                self.double_fallback_hit(hand)
            else
                :hit
            end     
        else
            :hit
        end
    end

    def self.double_fallback_hit(hand)
        if self.can_double(hand)
            :double
        else
            :hit
        end
    end

    def self.can_double(hand)
        EuropeanRules.new.can_double(hand) # TODO: don't repeat
    end 

    def self.soft_recommendation(hand, dealer_card)
        case hand.best_value
        when 19..21 then
            :stand
        when 18 then
            if (9..11).include?(dealer_card.bj_highest_value)
                :hit
            else
                :stand
            end
        else
            :hit
        end
    end
end
