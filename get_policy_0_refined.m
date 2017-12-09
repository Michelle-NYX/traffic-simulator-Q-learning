% Policy_0_refined = get_policy_0_refined(state)

% clear all
%% Create Policy_0_refined
% Policy_0_refined = zeros(1458,0);
% 
% for state = 1:1458
%     msg = state2msg(state);
%     action = 3;
%     
%     if msg.fc_d == 1 && msg.fc_v == 1
%         action = 5;
%     elseif msg.fc_d == 2 && msg.fc_v == 1
%         action = 4;
%     end 
%     
%     Policy_0_refined(state) = action;
% end
% csvwrite('Policy_0_refined.csv',Policy_0_refined);


%% Refining policy
% Policy_0 = csvread('Policy_0_refined.csv')';
% N = csvread('N_alpha_0.2_episode_10000_w5_1_epsilon_0.1.csv');
% Q = csvread('Q_alpha_0.2_episode_10000_w5_1_epsilon_0.1.csv');

[~, Policy_1] = max(Q,[],2);
N_state = sum(N,2);

Ind = (N_state < 30);

Policy_1_refined = Policy_1;
Policy_1_refined(Ind) = Policy_0(Ind);
csvwrite('Policy_1_refined_alpha_0.2_episode_10000_w5_1_epsilon_0.1.csv',Policy_1_refined);
