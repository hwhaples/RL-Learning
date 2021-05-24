function outputQ = q_learning(Q, current_state,current_action,new_state,alpha,reward,gamma)
    % Populates a Q-Table with State-Action-Reward-State-Action algorithm
    % Parameters:
    %   Q                       -- current Q-Table
    %   current_state           -- current state of agent
    %   curent_action           -- current action of agent
    %   new_state               -- next state of the agent
    %   alpha                   -- learning rate
    %   reward                  -- agent reward for action
    %   gamma                   -- reward discount
    % Returns:
    %   output_Q                -- updated Q table
    
    test = Q(current_state,current_action) + ...
            alpha*(reward + gamma * qmax((Q(new_state, :))) - Q(current_state, current_action));
    if isempty(test)
        disp('Help')
    end
    
    Q(current_state,current_action) = ...
            Q(current_state,current_action) + ...
            alpha*(reward + gamma * qmax((Q(new_state, :))) - Q(current_state, current_action));
    
    outputQ = Q;
end

function my_max = qmax(data)
    % Returns non-zero maximum of a data vector
    my_max = max(data(data ~= 0));
    if isempty(my_max)
        my_max = 0;
    end
end