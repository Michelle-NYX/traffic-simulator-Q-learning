function [output, frames, if_bad_init] = simulate(num_cars, simulate_horizon, Policy_1, plot_flag, Params, if_saving_gif)

% used for simulate for 200s with ego_car controlled by Policy_1
%% initialization
% Initizlie and Construct the traffic environment
Cars = simulator_initializaiton(Params, num_cars);

if if_saving_gif == false
    frames = [];
end

time = 0;
tot_dist = 0;
lane_change_times = 0;
if_bad_init = false;

ego_obs = get_Observation(1, Cars, Params);

if plot_flag
    if if_saving_gif
        fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
        hold on;
        Plot_Traffics(Cars, time, tot_dist, Params, ego_obs, fig);
    else
        Plot_Traffics_not_saving_gif(Cars, time, tot_dist, Params, ego_obs);
    end
end

for time = 1 : simulate_horizon
    %% update dynamics, with relative coord, i.e. ego_x = 0;
%     s = obs2state(ego_obs, Params);

    ego_obs = get_Observation(1, Cars, Params);
    
    [Cars, tot_dist, ~, lane_change_flag] = update_dynamics_simu(Cars, tot_dist, Policy_1, Params);
    
    % check if there is collision:
    collision_flag = check_collision(Cars, Params);
    
    % update Q
%     a = ego_action;
%     s_n = obs2state(ego_obs, Params);
    
   %% 
    if collision_flag == false
        if plot_flag
            if if_saving_gif
                frames(time) = Plot_Traffics(Cars, time, tot_dist, Params, ego_obs, fig);
            else
                Plot_Traffics_not_saving_gif(Cars, time, tot_dist, Params, ego_obs);
            end
        end
        
        if lane_change_flag
            lane_change_times = lane_change_times + 1;
        end
    else
        % filter bad initialization
        frames = [];
        if time >= 3
            disp('Collision++');
            
            if plot_flag
                if if_saving_gif
                    Plot_Traffics(Cars, time, tot_dist, Params, ego_obs, fig);
                else
                    Plot_Traffics_not_saving_gif(Cars, time, tot_dist, Params, ego_obs);
                end
            end
        else
            disp('Bad initialization!');
            if_bad_init = true;
            tot_dist = 0;
            collision_flag = false;
        end
        
        break; % break the current episode & restart simulation
        
    end % collision check
    
end % for time

output = [tot_dist, collision_flag, lane_change_times];

return