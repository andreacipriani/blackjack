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
                return :stand
            else
                return :split
            end
        when 8 then
            return :split
        when 7 then
            if [8, 9, 10, 11].include?(dealer_card.bj_highest_value)
                return :hit
            else
                return :split
            end
        when 6 then
            if [7, 8, 9, 10, 11].include?(dealer_card.bj_highest_value)
                return :hit
            else
                return :split
            end
        when 5 then
            if [10, 11].include?(dealer_card.bj_highest_value)
                return :hit
            else
                return :double
            end
        when 4 then
            if [5, 6].include?(dealer_card.bj_highest_value)
                return :split
            else
                return :hit
            end
        else
            if [8, 9, 10, 11].include?(dealer_card.bj_highest_value)
                return :hit
            else
                return :split
            end 
        end
    end

    # TODO:  implement from https://www.blackjackapprenticeship.com/blackjack-strategy-charts/
    def self.soft_recommendation(hand, dealer_card)
        :hit
    end

    def self.hard_recommendation(hand, dealer_card)
        case hand.value
        when 8 then :hit
        when 9 then
            if dealer_card.is_ace?
                :hit
            elsif dealer_card.bj_value.between?(3,6)
                :double
            else
                :hit
            end
        when 12 then
            :stand
        when 18 then
            :stand
        else 
            :hit
        end
    end
end
