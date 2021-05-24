classdef blackjack < handle
    %BLACKJACK - Implements a blackjack game given players
    % Get rid of N-Players and player list.
    properties
        player_list          % Cell array containing player objects 
        playing_cards        % Specifies deck to play with
        round_complete       % Boolean specifying if all players have played
    end
    
    properties(Dependent)
        n_players            % Number of players in the game
        visible              % Gets the cards visible to a given player
        winner               % Contains the player who won the round.
        scores               % Contains a list of all player scores.
    end

    methods
        function obj = blackjack(player_list,deck)
            % CONSTRUCTOR Defines an instance of a blackjack game.
            obj.player_list = player_list;       % Set the number of players
            obj.playing_cards = deck;            % Provide the deck to play with
            obj.round_complete = false;          % Round incomplete
        end
        
        function winner = get.winner(obj)
            % Gets the index of the winner in the winner list
            max_score = 0;
            winner = [];
            if obj.round_complete
                for i = 1:length(obj.player_list)
                    current_player = obj.player_list{i};
                    if current_player.Score > max_score && not(current_player.IsBust)
                        max_score = current_player.Score;
                        winner = i;
                    end
                end
            else
                winner = [];
                warning('Warning: Round has not been completed, winner = []')
            end
        end
        
        function n_players = get.n_players(obj)
            % Returns the number of players in a blackjack game
            n_players = length(obj.player_list);
        end
        
        function deal(obj)
            % Deals the cards at the beginning of a match
            for i = 1:2
                for j = 1:length(obj.player_list)
                    current_player = obj.player_list{j};
                    current_player.Draw(obj.playing_cards);
                end
            end
        end
        
        function play(obj)
            % Plays a single round of blackjack
            obj.deal;                            % Deal the cards
            for i = 1:length(obj.player_list)    % Iterate turns
                current_player = obj.player_list{i};
                current_player.Play(obj.playing_cards);
            end
            obj.round_complete = true;           % Round complete
        end
        
        function visible = get.visible(obj)
            % Returns the visible cards for a given player
            visible = {};
            for i = 1:length(obj.player_list)
                current_player = obj.player_list{i};
                if i == length(obj.player_list)  % Dealer is the last player
                    visible{i} = current_player.Hand(2:end);
                else
                    visible{i} = current_player.Hand;
                end
            end
        end
        
        function scores = get.scores(obj)
            % Gets the scores of all of the current players
            scores = zeros(1,length(obj.player_list));
            for i = 1:length(obj.player_list)
                current_player = obj.player_list{i};
                scores(i) = current_player.Score;
            end
        end
        
        function Reset(obj)
            % Resets a game - all hands, all deck, all flags
            obj.playing_cards.Reset
            for i = 1:length(obj.player_list)
                current_player = obj.player_list{i};
                current_player.Reset;
            end
            obj.round_complete = false;
        end
    end
    
end