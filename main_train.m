clear;

% cd Parameters/
% Q_0 = csvread('Q_alpha_0.2_episode_10000_w5_1.csv');
% cd ..

MAX_STATES_NUM = 3^6 * 2;
ACTION_NUM = 6;
Q_0 = zeros(MAX_STATES_NUM, ACTION_NUM);

setting_str = 'alpha_0.2_episode_10000_w5_1_test';
episode_limit = 10000;
time_limit    = 10*3600;     % in [seconds]
plot_flag     = false;  % usually not plot during training
epsilon       = 0.1;      % eps-greedy
if_eps_decay  = false;   % if anneal epsilon
decay_rate    = 20;      % greater decay_rate, faster eps decays
gamma         = 0.9;    % discount factor
alpha         = 0.2;    % learning rate

train_Q(Q_0, setting_str, episode_limit, time_limit, plot_flag,...
        epsilon, if_eps_decay, decay_rate, gamma, alpha);
