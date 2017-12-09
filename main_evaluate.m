clear;

cd Parameters
%%%%%%% Read Policy_1 from a Q file:
% Q = csvread('Q_alpha_0.2_episode_10000_w2_10_w5_0.1.csv');
% [~, Policy_1] = max(Q,[],2);
%%%%%%% OR read Policy_1 from a policy file:
Policy_1 = csvread('Policy_1_refined_alpha_0.2_episode_10000_w5_1_epsilon_0.1.csv');
% Policy_1 = Policy_1(:);
cd ..

plot_flag     = false;
if_saving_gif = false;


simu_times       = 500;
simulate_horizon = 200;
min_car_num      = 15;
max_car_num      = 40;


[Colli_rate, Performance, Lane_change_times] =  ...
    evaluate_policy(Policy_1, plot_flag, if_saving_gif, ...
                    simu_times, simulate_horizon, min_car_num, max_car_num);

setting_str = 'alpha_0.2_episode_10000_w5_1_epsilon_0.1';             
cd Evaluation/
csvwrite(['Colli_rate_' setting_str '.csv'], Colli_rate);
csvwrite(['Performance_' setting_str '.csv'], Performance);
csvwrite(['Lane_change_times_' setting_str '.csv'], Lane_change_times);
cd ..
