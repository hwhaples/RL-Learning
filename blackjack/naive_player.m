classdef naive_player < player
    % NAIVE_PLAYER - sublcass to the player class describing a simple
    % blackjack strategy.
    
    methods
        function obj = naive_player(Hand)
            % CONSTRUCTOR - establishing a naive player.
            if nargin == 0
                Hand = [];
            end
            obj = obj@player(Hand);
        end
        
        function Play(obj,deck)
            % Overwrites the Play method in the player class to implement a
            % simple strategy. The player draws if their hand is less than
            % 17.
            while not(obj.IsBust)
                if obj.Score < 17
                    obj.Draw(deck)
                else
                    break
                end
            end
            
        end
    end
end