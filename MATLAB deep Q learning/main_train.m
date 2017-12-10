clear,close all,clc

% cd Parameters/
% Q_0 = csvread('Q_alpha_0.2_episode_10000_w5_1.csv');
% cd ..

policy1=csvread('sample_policy.csv');


setting_str = 'deep_episode_10000_w5_1_test';
episode_limit = 5000;
time_limit    = 1*3600;     % in [seconds]
plot_flag     = false;  % usually not plot during training
epsilon       = 0;      % eps-greedy
if_eps_decay  = false;   % if anneal epsilon
decay_rate    = 2000;      % stop episode
gamma         = 0.99;    % discount factor


net_out=train_Q(setting_str, episode_limit, time_limit, plot_flag,...
        epsilon, if_eps_decay, decay_rate, gamma,policy1);
