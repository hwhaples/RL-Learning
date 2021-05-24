classdef deck < handle
    % DECK - definition of a deck object for a blackjack card game

    properties
        Cards
        Current_cards
    end
    properties (Access = private)
        Standard = {2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9, ...
                    10,10,10,10,'J','J','J','J','Q','Q','Q','Q','K','K','K','K','A','A','A','A'};
    end

    methods
        function obj = deck(cards)
            % CONSTRUCTOR of an deck instance with user-definable cards
            if nargin == 0
                obj.Cards = obj.Standard;
            else
                if iscell(cards)
                    obj.Cards = cards;
                else
                    warning('WARNING - Given cards invalid, must be type "cell"')
                    obj.Cards = obj.Standard;
                end
            end
            
            obj.Current_cards = obj.Cards;
        end
        
        function Reset(obj)
            % Resets the card deck
            obj.Current_cards = obj.Cards;
        end
        
        function card = Draw_card(obj)
            % Draws a card from the deck, returns the card, and removes the
            % card from current draws.
            all_cards = obj.Current_cards;
            i = randi(length(all_cards));       % Pick a random card index
            card = all_cards{i};                % Draw the card
            all_cards(i) = [];                  % Delete card
            obj.Current_cards = all_cards;
        end
        
        function Return_card(obj, card)
            % Returns a card to the deck (for use with robots "looking ahead")
            all_cards = obj.Current_cards;
            all_cards{end + 1} = card;
            obj.Current_cards = all_cards;
            
        end
    end
end