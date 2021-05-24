function outputQ = sarsa(Q, current_state,current_action,new_state,new_action,alpha,reward,gamma)
    % Populates a Q-Table with State-Action-Reward-State-Action algorithm
    % Parameters:
    %   Q                       -- current Q-Table
    %   current_state           -- current state of agent
    %   curent_action           -- current action of agent
    %   new_state               -- next state of the agent
    %   new_action              -- next action of the agent
    %   alpha                   -- learning rate
    %   reward                  -- agent reward for action
    %   gamma                   -- reward discount
    % Returns:
    %   output_Q                -- output Q
    
    Q(current_state,current_action) = ...
            Q(current_state,current_action) + ...
            alpha*(reward + gamma * Q(new_state, new_action) - Q(current_state, current_action));
    
    outputQ = Q;
end