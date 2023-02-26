# Reference: https://www.blackjackapprenticeship.com/wp-content/uploads/2018/08/BJA_Basic_Strategy.jpg

class BasicStrategy
    def initialize(rules)
        @rules = rules
    end

    def recommendation(hand, dealer_card)
        if hand.cards.size == 1
            return :hit # In case of splits you start with one card
        end
        # If hand is a Pair, evaluate differently, considering split
        if hand.is_pair?
            return pair_recommendation(hand, dealer_card)
        end
        if hand.is_soft?
            soft_recommendation(hand, dealer_card)
        else
            hard_recommendation(hand, dealer_card)
        end
    end

    private

    def pair_recommendation(hand, dealer_card)
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
                double_fallback_hit(hand)
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

    def hard_recommendation(hand, dealer_card)
        case hand.best_value
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
                double_fallback_hit(hand)
            end
        when 9 then
            if (3..6).include?(dealer_card.bj_highest_value)
                double_fallback_hit(hand)
            else
                :hit
            end     
        else
            :hit
        end
    end

    def double_fallback_hit(hand)
        if can_double(hand)
            :double
        else
            :hit
        end
    end

    def can_double(hand)
        @rules.can_double(hand)
    end 

    def soft_recommendation(hand, dealer_card)
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
