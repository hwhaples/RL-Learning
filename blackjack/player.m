classdef player < handle
    % PLAYER - definition of a player object for a blackjack card game
    %   This class contains the properties of a player in a blackjack card
    %   game. This class supports a blackjack game and defines actions the
    %   player can make.

    properties
        Hand                    % Cards a player currently has
    end
    properties (Dependent)
        Score                   % Player's current score
        IsBust                  % Boolean for if the player is bust
    end

    methods
        function obj = player(Hand)
            % CONSTRUCTOR of an instance of a player by indicating player type
            % A player is defined by being Human, Naive, or a trained NN
            if nargin == 0
                obj.Hand = [];
            else
                obj.Hand = Hand;
            end
        end
        
        function Score = get.Score(obj)
            % Gets a player's score from their current hand.
            hand = obj.Hand;
            Score = 0;
            for i = 1:length(hand)
                if isnumeric(hand{i})
                    Score = Score + hand{i};
                elseif hand{i} ~= 'A'
                    Score = Score + 10;
                elseif hand{i} == 'A'
                    if Score + 11 <= 21
                        Score = Score + 11;
                    else
                        Score = Score + 1;
                    end
                end
            end
        end
        
        function IsBust = get.IsBust(obj)
            % Determines if a player is bust or not
            if obj.Score > 21
                IsBust = true;
            elseif obj.Score <= 21
                IsBust = false;
            end
        end
        
        function Draw(obj,deck,n_cards)
            % Draws a card from a deck object and adds it to a player's
            % hand.

            if ~exist('n_cards','var')
                n_cards = 1;
            end

            for i = 1:n_cards
                card = deck.Draw_card;
                hand = obj.Hand;
                hand{end+1} = card;
                obj.Hand = hand;
            end
        end
        
        function Reset(obj)
            % Resets a player's hand to empty
            obj.Hand = [];
        end
        
        function Play(obj,deck)
            % Abstract class describing how a player makes a move
            
        end
        
    end
end