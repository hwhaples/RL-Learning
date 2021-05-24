classdef ql_player < player
    %Q-Learning Player - Makes player decisions based on a q-learning or
    %sarsa algorithm. THe Algorithm is "SIMPLE" because its state
    %definition is purely based on the current score.
    
    properties
        Q           % Q-Table
    end
    
    methods
        function obj = ql_player(Q,Hand)
            % CONSTRUCTOR - establishing a player that uses a Q-table to
            % make a move.
            
            
            if ~exist('Hand','var')
                Hand = [];
            end
            
            if ~exist('Q','var')
                Q = [];
            end
            
            obj = obj@player(Hand);
            obj.Q = Q;
        end
        
        function state = GetState(obj)
            % Returns Q-Table state of a player's given hand
            state  = obj.Score;
        end
        
        function action = GetAction(obj,state,epsilon)
            % Determines the action a player takes from the Q-table
            % Epsilon contains the chance for mutation.
            % 1 = hit, 2 = stand
            if obj.IsBust           % if bust, you must stand
                action = 2;         
            elseif rand > epsilon   % Optimal(greedy) decision
                [~,action] = max(abs(obj.Q(state,:)));
            else
                [~,action] = min(abs(obj.Q(state,:)));
            end
        end
            
        function [next_state,card_value] = GetNextState(obj,state,action,deck)
            % Gets the probable next state from the deck.
            % NOTE: This is imperfect since the learner now implicitly
            % knows the dealer's hidden card. This may be fixed by editing
            % the blackjack and deck objects.
            if action == 1     % Hit
                card = deck.Draw_card;
            elseif action == 2 % Stand
                card = 0;
            end
            

            if isnumeric(card)
                card_value = card;
            elseif card ~= 'A'
                card_value = 10;
            elseif card == 'A'
                if state + 11 <= 21
                    card_value = 11;
                else
                    card_value = 1;
                end
            end
                
            next_state = state + card_value;        % Hypothetical future state (stochastic)
            if card_value ~= 0
                deck.Return_card(card);                 % Returns the card
            end
        end
        
        function reward = GetReward(obj,state,card_value)
            % Returns the reward from the hypothetical actions
            reward = state + card_value;
            if obj.Score <= 21
                reward = obj.Score;
            elseif reward > 21
                reward = -10;
            end
        end
            
        
        function [Q,current_action] = SARSA(obj, alpha, gamma, epsilon, deck)
            % Evalulates Q table using the SARSA algorithm
            Q = obj.Q;
            current_state = obj.GetState;
            current_action = obj.GetAction(current_state,epsilon);
            [next_state,card_value] = obj.GetNextState(current_state,current_action,deck);
            next_action = obj.GetAction(next_state,epsilon);
            
            reward = obj.GetReward(current_state,card_value);
            

            Q(current_state,current_action) = ...
                alpha * (reward + gamma * Q(next_state,next_action) - Q(current_state,current_action));
            
            obj.Q = Q;
        end
        
        function Q = QLEARNING(obj, alpha, gamma, epsilon, deck)
            % Evaluates a Q table using the Q-Learning Algorithm
            Q = obj.Q;
            current_state = obj.GetState;
            current_action = obj.GetAction(current_state, epsilon);
            [next_state,card_value] = obj.GetNextState(current_action,deck);
            next_action = obj.GetAction(next_state,-1);     % In Q-Learning, the next action is always Greedy
            
            reward = obj.GetReward(current_state,card_value);
            
            Q(current_state,current_action) = ...
                alpha * (reward + gamma * Q(next_state, next_action) - Q(current_state,current_action));
            
            obj.Q = Q;
        end
            
        
        function Play(obj,deck)
            % Play a game making decisions based on a Q-table and epsilon
            % Greedy algorithm
            while not(obj.IsBust)
                state = obj.GetState;                         % Returns row in Q-table
                action = obj.GetAction(state, -1);            % Picks the action (1 = hit, 2 = stand)
                if action == 1
                    obj.Draw(deck);     % Hit
                elseif action == 2
                    break               % Stand
                end
            end
            
        end
    end
end

