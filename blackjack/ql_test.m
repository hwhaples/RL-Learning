% Written by Hunter Whaples on 5/23/2021 for Prof. R. Wang, HMC
% This script tests a populated Q-Table using ql_train.m and takes
% measurements to compare performance of the ql_player against the naive
% player.

%% Create the environment
% Assume the existance of a populated Q-Table
Q2 = rand(31,2);

p1 = ql_player(Q);
p2 = naive_player;
player_list = {p1,p2};

d = deck;

bl = blackjack(player_list, d);

%% Test the QL Performance Against the naive dealer in n games

n_games = 1000;      % Play this many games
naive_wins = 0;      % Counter for when dealer wins
naive_scores = [];   % List containing the ql scores every g
ql_wins    = 0;      % Counter for when ql player wins
ql_scores  = [];     % List containing the ql scores every game

no_winner = 0;       % Both players go bust

for i = 1:n_games
    bl.play;
    sprintf('Game number: %d, Winner is: %d',i,bl.winner);
    if bl.winner == 1
        ql_wins = ql_wins + 1;
    elseif bl.winner == 2
        naive_wins = naive_wins + 1;
    else
        no_winner = no_winner + 1;
    end
    ql_scores = [ql_scores, p1.Score];
    naive_scores = [naive_scores, p2.Score];
    bl.Reset;
    d.Reset;
end

%% Visualize
figure(1)
Y = [ql_wins, naive_wins, no_winner];
bar(Y);
title(['Wins out of ', num2str(n_games), ' games']);
set(gca,'xticklabel',{'QL-Wins','Naive Wins', 'Both Bust'})

text(1:length(Y),Y,num2str(Y'),'vert','bottom','horiz','center'); 
box off

figure(2)
subplot(2,1,1)
histogram(ql_scores, max(ql_scores));
title('QL Scores');

subplot(2,1,2)
histogram(naive_scores, max(naive_scores));
title('Naive Scores')