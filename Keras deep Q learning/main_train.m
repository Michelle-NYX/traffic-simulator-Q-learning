clear;

cd Parameters/
Q_0 = csvread('Q_alpha_0.2_episode_5000_w2_10_w5_0.1.csv');
cd ..



train_Q(Q_0, setting_str, episode_limit, time_limit, plot_flag,...
        epsilon, if_eps_decay, decay_rate, gamma, alpha);
