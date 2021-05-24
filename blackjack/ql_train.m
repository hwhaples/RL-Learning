% Written by Hunter Whaples on 5/22/2021 for Prof. R. Wang, HMC
% This script populates the Q-table for an RL-driven blackjack player.

%% Initialize Training Parameters

Q = rand(31,2);              % There are 30 possible scores that you can have
eps   = 0.2;                 % Epsilon
alpha = 0.1;                 % Learning Rate
gamma = 0.7;                 % Reward Discount

current_episode = 1;
max_episode = 100000;       % Maximum games to be played
max_steps = 20;              % Never a need to run a game more than 20 steps

rng(10);                     % Set random seed

%% Create environment game variables

p = ql_player(Q);
d = deck;

%% Perform iterative learning

while current_episode <= max_episode
    step = 1;
    current_action = 1;
    while current_action ~= 2 && not(p.IsBust) && p.Score ~= 21
        if isempty(p.Hand)
            p.Draw(d,2);                                       % Get dealt 2 cards
        end
        [~,current_action] = p.SARSA(alpha,gamma,eps,deck);    % Perform SARSA Update
        step = step + 1;           % Step Increment
        if current_action == 1     % If hit
            p.Draw(d);
        end
        if step >= max_steps
            break
        end
    end
    % Reset the deck and player
    d.Reset;
    p.Reset;
    current_episode = current_episode + 1;
    disp(current_episode);
end