
function train_Q(Q, setting_str, episode_limit, time_limit, plot_flag,...
                    epsilon, if_eps_decay, decay_rate, gamma, alpha)

max_states_num = 3^6 * 2;
action_num = 6;

N = zeros(max_states_num, action_num);
score = zeros(episode_limit, 1);

K = decay_rate / episode_limit;


start_time = tic;
for episode = 1 : episode_limit
    
    % epsilon anealing
    if if_eps_decay
        epsilon = 1 * exp(- K * episode);
    end
    
    fprintf('\nepisode = %d\n', episode);
    num_env_cars = randi(5) + 20;

    [Q, score(episode), collision_flag, N] ...
        = Q_learning(Q, N, num_env_cars, plot_flag, epsilon, gamma, alpha);
    
    
    plot_score(score(episode), episode, collision_flag, epsilon);
    
    if mod(episode, 1000) == 0
        cd Parameters
        csvwrite(['Q_' setting_str '.csv'], Q);
        csvwrite(['score_' setting_str '.csv'], score);
        csvwrite(['N_' setting_str '.csv'], N);
        [~, Policy_1] = max(Q,[],2);
        csvwrite(['Policy_1_' setting_str '.csv'], Policy_1);
        cd ..
    end
    
    if toc(start_time) > time_limit
        break;
    end
    
    if plot_flag == true
        close all;
    end
    
end % for episode

cd Parameters
csvwrite(['Q_' setting_str '.csv'], Q);
csvwrite(['score_' setting_str '.csv'], score);
csvwrite(['N_' setting_str '.csv'], N);
[~, Policy_1] = max(Q,[],2);
csvwrite(['Policy_1_' setting_str '.csv'], Policy_1);
cd ..

figure;
image(N);
