# RL-Learning
Building RL Algorithms from Scratch in Matlab

Scripts and functions written by Hunter Whaples in collaboration with Prof. R. Wang at Harvey Mudd College. The goal of these programs is to demonstrate reinforcement learning in a 4 - connected grid world.

Algorithms:
  - SARSA.m:     implements the SARSA algorithm to solve an m x n maze
  
To Do:
  - Implement Q-Learning
  - Separate Code Into Functions for Readability
  - Implement Graphics to Track Reward Over Each Episode of Training
  - Implement RL by training a (deep) neural network rather than Q table
  
 Known Bugs:
  - SARSA.m gets caught in oscillations when offered a non-exit reward for taking a longer than optimal path.
