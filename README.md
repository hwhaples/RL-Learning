# RL-Learning
Building RL Algorithms from Scratch in Matlab

Scripts and functions written by Hunter Whaples in collaboration with Prof. R. Wang at Harvey Mudd College. The goal of these programs is to demonstrate reinforcement learning concepts in a variety of self-made environments. The current environments are:

  - Maze:      A four-connected grid environment where an agent attempts to find an optimal path to the exit.
  - Blackjack: A simplified blackjack environment in which an agent attempts to learn when to hit or stand in blackjack. This environment does not include the possibility of splitting and does not give extra points for a natural blackjack. The current RL agent does makes decisions purely based on a Q-table using the current score (rather than cards on the table) as the state.

### Algorithms:
  - SARSA.m:     implements the SARSA algorithm to solve an m x n maze
  
### To Do:
  - Implement RL by training a (deep) neural network rather than Q table
  - Thoroughly test blackjack environment and report results on blog

### Completed:
  - Implement Q-Learning (Maze)
  - Implement Graphics to Track Reward and Steps During Training (Maze)
  - Separate Code Into Functions

### Known Bugs:
  - SARSA.m gets caught in oscillations when offered a non-exit reward for taking a longer than optimal path.
