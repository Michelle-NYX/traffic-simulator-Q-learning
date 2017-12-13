# traffic-simulator-Q
We propose a driver modeling process and its evaluation results of an intelligent autonomous driving policy, which is obtained through reinforcement learning techniques. 
Assuming a MDP decision making model, Q-learning method and deep Q-learning method are applied to simple but descriptive state and action spaces, so that a policy is developed within limited computational load. 
The driver could perform reasonable maneuvers, like acceleration, deceleration or lane-changes, under usual traffic conditions on a multi-lane highway.
A traffic simulator is also construed to evaluate a given policy in terms of collision rate, average travelling speed, and lane change times. Results show the policy gets well trained under 
reasonable time periods, where the driver acts interactively in the stochastic traffic environment, demonstrating low collision rate and obtaining higher travelling speed than the average of the environment. 
Sample intelligent driver demonstration videos are posted on YouTube.
https://youtu.be/OFRZzvPH30g

Usage: 
> run main_train.m for Q-learning
> run main_evaluate.m for evaluating policies
