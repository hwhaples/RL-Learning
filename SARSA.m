% The following matlab script introduces SARSA and Q-Learning as methods of
% solving a Grid World Maze

%% Creating Maze Environment
clear
clc
clf
% Define the environment parameters 
m      = 10;     % rows
n      = 10;     % columns
exit   = m*n;   % exit bottom right corner
reward = 10;    % reward for reaching exit
wall   = -100;  % const. representing impassable wall
penalty = -1;   % cost of moving

maze = generate_maze(m,n,exit,reward,wall,penalty);

% Hard-coded 6x6 maze - if random generation unwanted.
% maze = [-1,-1,-1,-1,-100,-1, -1; ...
%         -100, -100, -1, -1, -100, -100,-1;...
%         -1, -100, -100, -1, -1,-1,-1;...
%         -1, -100, -1, -1, -100, -100,-1; ...
%         -1, -1, -100, -1, -1, -1,-1;...
%         -100, -1, -1, -1, -100, -1, -1;
%         -100,-100,-100,-100,-100,-100,10];

figure(1)
imagesc(maze);
title('Reward Maze');
colormap("autumn");
axis off

%% Defining SARSA

% I would like to turn this into a function
% For now it will use a script

% Initializing Parameters
Q = zeros(numel(maze),4);    % Initalize state values to 0, each has 4 actions
eps   = 0.2;                 % Epsilon
alpha = 0.1;                 % Learning Rate
gamma = 1;                   % Reward Discount
start_state = 1;             % Starting Location
goal_state  = exit;          % Ending Location

current_episode = 1;         % Counter
max_steps       = 1000;      % Maximum number of steps an episode can run
max_episode     = 300;       % Maximum number of episodes

total_iters     = [];        % Stores the total iterations per episode

rng(69)                      % Repeatable results

active_maze = maze;          % Copy of maze environment

% Perform Iterative Learning
while current_episode <= max_episode
    current_state  = start_state;        % Set intial condition
    current_action = get_action(current_state,active_maze,Q,eps); % Random action is chosen
    
    % Begin Simulation in Environment
    step = 1;
    while current_state ~= goal_state
        % Get the new state given current state and action
        new_state  = get_new_state(current_state, current_action, active_maze);
        
        % Calculate reward given current state and action
        reward     = get_reward(current_state, current_action, active_maze);
        
        % Look for the next action using the same policy
        new_action = get_action(new_state,active_maze,Q,eps);
        
        % Sarsa Implementation
        Q(current_state,current_action) = ...
            Q(current_state,current_action) + ...
            alpha*(reward + gamma * Q(new_state, new_action) - Q(current_state, current_action));
        
%         % If you are not on a normal tile and not at the goal
%         if active_maze(current_state) ~= -1 && current_state ~= goal_state
%             active_maze(current_state) = -1;    % "consume" the reward, setting tile to normal
%         end
        
        % Iteration Management
        step = step + 1;             % Iterate Counter
        current_state  = new_state;  % Update State 
        current_action = new_action; % Update Action
        if step > max_steps
            break;
        end
    end
    total_iters = [total_iters, step];
    current_episode = current_episode + 1;
    
    active_maze = maze;              % reset the maze after iteration
end

%% Gather Optimal Path
% Now that we have trained the Q-table we can visualize the path found by
% the final episode.
final_episode = [start_state];
counter = 1;
while final_episode(end) ~= goal_state
    current_state = final_episode(end);
    action = get_action(current_state, active_maze, Q, -1);     % always greedy
    state  = get_new_state(current_state, action, active_maze);
    final_episode = [final_episode, state];
    
    

    %%%%%%%%%%%%%%%%%%%%%
    counter = counter + 1;
    if counter > 50
        break
    end
end

%% Print/Visualize Results
disp('---Learning Parameters---');
fprintf('Alpha (learning rate): %.1s. Gamma (discounted reward): %d. Epsilon: %.1d. \n', alpha, gamma, eps);
disp('---Solution---');
disp(final_episode);

[m,n] = size(maze);
solution = zeros(size(maze));
for i = 1:length(final_episode)
    [row,col] = state2idx(final_episode(i),maze);
    if i == 1
        solution(row,col) = 2;
    else
        solution(row,col) = 1;
    end
end
figure(2)
imagesc(maze);
for i = 1:m
    for j = 1:n
        if maze(i,j) == min(min(maze))
            text(j,i,'X','HorizontalAlignment','center');
        end
        if solution(i,j) == 1 || solution(i,j) == 2
            text(j,i, '\bullet', 'Color', 'red', 'FontSize', 28, 'HorizontalAlignment','center');
            if solution(i,j) == 2
                text(j,i,'Start','HorizontalAlignment','center','VerticalAlignment','baseline');
            end
        end
    end
end
text(n,m,'Goal','HorizontalAlignment','center', "VerticalAlignment","baseline")
%colormap("autumn");
axis off

%% Helper Functions

function reward = get_reward(state,action,maze)
    % Returns a the reward given a state and an action. This function is
    % specific to the maze environment and set of possible actions. The
    % following implementation will be for grid world.
    % Parameters:
    %   state       -- current location in maze
    %   action      -- selected action to progress to next state
    %   maze        -- matrix linking a reward with each state
    % Returns:
    %   reward      -- reward for performing the given action
    
    next_state = get_new_state(state,action,maze); % look forward
    [row,col] = state2idx(next_state, maze);
    %maze   = maze'; %<-- not a good solution
    reward = maze(row,col);
end

function new_state = get_new_state(state,action,maze)
    % Returns a new state given a state and an action. This function is
    % specific to the maze environment and set of possible actions. The
    % following implementation will be for grid world (without diagonal
    % motion).
    [M,~] = size(maze);
    switch action
%         case 1 % move up
%             new_state = state - N;
%         case 2 % move right
%             new_state = state + 1;
%         case 3 % move down
%             new_state = state + N;
%         case 4 % move left
%             new_state = state - 1;
        case 1 % move up
            new_state = state - 1;
        case 2 % move right
            new_state = state + M;
        case 3 % move down
            new_state = state + 1;
        case 4 % move left
            new_state = state - M;
    end

end

function selected_action = get_action(state, maze, Q, eps)
    % Will return the action to be taken. Picks as e-greedy alogrithm
    
    [M,N] = size(maze);       % Define the size of the environment
    %row   = ceil(state/N);    % Convert state number of matrix row/col
    %col   = mod(state-1,M)+1;
    [row, col] = state2idx(state,maze);
    
    possible_actions = [];
    
    % Look around in all four directions
    if row > 1 % Up
        r = row-1;
        c = col;
        if maze(r,c) ~= -100 % Check if this state is valid
            possible_actions = [possible_actions; 1, Q(state,1)];
        end
    end
    
    if row < M % Down
        r = row+1;
        c = col;
        if maze(r,c) ~= -100 % Check if this state is valid
            possible_actions = [possible_actions; 3, Q(state,3)];
        end
    end
    
    if col > 1 % Left
        r = row;
        c = col-1;
        if maze(r,c) ~= -100 % Check if this state is valid
            possible_actions = [possible_actions; 4, Q(state,4)];
        end
    end
    
    if col < N % Right
        r = row;
        c = col+1;
        if maze(r,c) ~= -100 % Check if this state is valid
            possible_actions = [possible_actions; 2, Q(state,2)];
        end
    end
    
    % Sort the possible actions with largest Q-Value
    possible_actions = sortrows(possible_actions,2,'descend');
    
    % Find how many best options we have from the current state
    n_bests = length(find(possible_actions(:,2)==max(possible_actions(:,2))));
    % Choose from the action
    if rand > eps
        % Usually randomly pick among the best options (greedy)
        random_idx = randi([1, n_bests],1,1);
    else
        % Sometimes choose a random non-optimal state;
        if size(possible_actions,1) == 1
            start = 1;
        else
            start = 2;
        end
        random_idx = randi([start, size(possible_actions,1)],1,1);
    end
    
    selected_action = possible_actions(random_idx,1);
end

function [row,col] = state2idx(state,maze)
    % Converts a state into row and column indices
    [~,n] = size(maze);
    col   = ceil(state/n);
    row   = mod(state-1,n)+1;
end