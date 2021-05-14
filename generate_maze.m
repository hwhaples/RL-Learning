function maze = generate_maze(m,n,exit,reward,wall,penalty,eps)
    % Generates an m x n maze to demonstrate SARSA and Q-learning
    % Parameters:
    %   m        -- (int) height of the maze
    %   n        -- (int) width of the maze
    %   exit     -- (int) idx of exit of the maze, default m * n
    %   wall     -- (int) signifier of a wall (default -100)
    %   penality -- (int) penalty of moving (default -1)
    %   eps      -- (float) how often to choose optimal pathing.
    % Returns:
    %   maze     -- (mat) m x n matrix containing a maze
    
    
    eps  = 0.8;         % how often to choose optimal path (0-1]
    maze = zeros(m,n);
    
    my_location = 1;    % start at the first location
    path = [my_location];
    while my_location ~= exit
        possible_moves = get_possible_moves(my_location,m,n);
        chosen_move = choose_move(possible_moves, n, exit, eps);
        path = [path,chosen_move];
        my_location = chosen_move;
    end
    
    maze(path) = penalty;
    for i = 1:numel(maze)
        if maze(i) == penalty
            continue
        else
            if rand > 0.6
                maze(i) = penalty;   % open space
            else
                maze(i) = wall;      % inaccessible space
            end
        end
    end
    
    maze(exit) = reward;             % give reward at the exit
end

function possible_moves = get_possible_moves(my_location,m,n)
    % Gets the possible moves from a given state
    % Parameters:
    %   my_location     -- index of current location
    %   m               -- number of rows
    %   n               -- number of columns
    % Returns:
    %   possible_moves  -- list of possible moves using matlab single
    %                      matrix indexing
    
    possible_moves = [];
    col   = ceil(my_location/n);
    row   = mod(my_location-1,n)+1;
    
    if row ~= 1    % not in first row, so we can go up
        possible_moves = [possible_moves, my_location - 1];
    end

    if col ~= 1    % not in first col, so we can go left
        possible_moves = [possible_moves, my_location - m];
    end
    
    if row ~= m    % not in last row, so we can go down
        possible_moves = [possible_moves, my_location + 1];
    end
    
    if col ~= n    % not in last column, so we can go right
        possible_moves = [possible_moves, my_location + m];
    end
    
    if possible_moves(end) > m*n
        disp('Help')
    end
end

function selected_move = choose_move(possible_moves, n, exit, eps)
    % Selects a move with propensity for selecting an "optimal" move
    %   possible_moves    -- matrix containing all possible moves
    %   m                 -- number of rows
    %   n                 -- number of columns
    %   exit              -- location where we are trying to go
    %   eps               -- float between [0,1] on when to choose optimal
    
    col   = ceil(possible_moves/n);
    row   = mod(possible_moves-1,n)+1;
    
    exit_col = ceil(exit/n);
    exit_row = mod(exit-1,n)+1;
    
    distances = zeros(size(col));
    for i = 1:length(col)
        distances(i) = manhattan_dist([row(i),col(i)],[exit_row,exit_col]);
    end
    
    % normally choose an optimal move (smallest distance)
    bests = find(distances==min(distances));
    
    if rand < eps
        selected_move = possible_moves(bests(randi(length(bests))));
    else
        selected_move = possible_moves(randi(length(distances)));
    end
end

function d = manhattan_dist(a,b)
    % Returns the manhattan distance between a and b
    
    d = sum(abs(bsxfun(@minus,a,b)),2);
end