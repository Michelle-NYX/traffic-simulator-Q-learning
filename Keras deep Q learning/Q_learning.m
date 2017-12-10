% lisheng 12/4/17
% This is actually a simulator

function [Q, score, collision_flag, N] ... 
    = Q_learning(Q, N, num_env_cars, plot_flag, epsilon, gamma, alpha)
%%
setGlobal;

%% initialization
% Initizlie and Construct the traffic environment
Cars = simulator_initializaiton(Params, num_env_cars);


time = 0;
dist = 0;
score = 0;

ego_obs = get_Observation(1, Cars, Params);
collision_flag = check_collision(Cars, Params);

if plot_flag
    Plot_Traffics_not_saving_gif(Cars, time, dist, Params, ego_obs);
end

%% Run with dynamics for a given time horizon
% beta version, ego car uses policy 0

for time = 1 : Params.time_step : Params.horizon
    %% update dynamics, with relative coord, i.e. ego_x = 0;
    s = obs2state(ego_obs, Params)
    ego_obs_t = ego_obs;
%     R = get_reward(ego_obs, Cars(1), collision_flag, Params);
    
    % update Cars
    [Cars, dist, ego_action] = Q_update_dynamics(Cars, dist, Params, Q, epsilon);
    
    % statistics
    N(s, ego_action) = N(s, ego_action) + 1;
    
    % check if there is collision:
    collision_flag = check_collision(Cars, Params);
    
    % update ego_obs
    % ego_obs of next time step:
    ego_obs = get_Observation(1, Cars, Params);
    
    R = get_reward(ego_obs_t, Cars(1), collision_flag, Params);
    
    a = ego_action;
    % update state to next state
    s_n = obs2state(ego_obs, Params);
    
   %% 
    if collision_flag == false
        
        Q(s,a) = Q(s,a) + alpha * (R + gamma * max(Q(s_n,:)) - Q(s,a));
        
        if plot_flag
            Plot_Traffics_not_saving_gif(Cars, time, dist, Params, ego_obs);
        end
    else
        % filter bad initialization
        if time >= 3
            
            Q(s,a) = Q(s,a) + alpha * (R + gamma * max(Q(s_n,:)) - Q(s,a));
            score = (dist-4000)/1000;
            
            disp('Collision!');
            fprintf('Distance Travelled = %3.4d m\n', dist);
            fprintf('Average Speed      = %3.2f m/s\n', dist/time);
            fprintf('Score              = %3.2f \n', score);
            
            if plot_flag
                Plot_Traffics_not_saving_gif(Cars, time, dist, Params, ego_obs);
            end
        else
            disp('Bad initialization!');
        end
        
        break; % break the current episode & restart simulation
        
    end % collision check
    
end % for time

%%
if collision_flag == false
    score = (dist-4000)/1000;
    disp('No Collision');
    fprintf('Distance Travelled = %3.4d m\n', dist);
    fprintf('Average Speed      = %3.2f m/s\n', dist/time);
    fprintf('Score              = %3.2f \n', score);
end

return



