% lisheng 12/4/17

% NYX 11/29/17 12:33 comment: 
% 1) simulator should deal with collision cases -- e.g. restart? or set a
%    collision flag and return to main;
% 2) seperate a new function which transfers action id to dynamics;
% 3) call plot at main function

function Simulator(num_env_cars, plot_flag)
% function Q = Simulator(Q, num_env_cars, plot_flag)
%%
setGlobal;

%% initialization
% Initizlie and Construct the traffic environment
Cars = simulator_initializaiton(Params, num_env_cars);

time = 0;
dist = 0;

ego_obs = get_Observation(1, Cars, Params);

if plot_flag
    Plot_Traffics(Cars, time, dist, Params, ego_obs);
end

%% Run with dynamics for a given time horizon
% beta version, ego car uses policy 0

for time = 1 : Params.time_step : Params.horizon
    %% update dynamics, with relative coord, i.e. ego_x = 0;
    [Cars, dist, ego_action] = update_dynamics(Cars, dist, Params);
    % Further, select action according to Q table
    % [Cars, dist, ego_action] = update_dynamics(Cars, dist, Params, Q);
    
    % check if the new positions are valid, i.e. check if there is collision:
    collision_flag = check_collision(Cars, Params);
    
    %%
    ego_obs = get_Observation(1, Cars, Params);
    R = get_reward(ego_obs, Cars(1), collision_flag, Params);
    % Q = update_Q(Q, R, ego_action, new_state);
    
   %% 
    if collision_flag == false
        if plot_flag
            Plot_Traffics(Cars, time, dist, Params, ego_obs);
        end
    else
        disp('Collision!');
        fprintf('Distance Travelled = %3.4d m\n', dist);
        fprintf('Average Speed      = %3.2f m/s\n', dist/time);
        if plot_flag
            Plot_Traffics(Cars, time, dist, Params, ego_obs);
        end
        break; % break the current episode & restart simulation
    end % collision check
end
%%
if collision_flag == false
    disp('No Collision');
    fprintf('Distance Travelled = %3.4d m\n', dist);
    fprintf('Average Speed      = %3.2f m/s\n', dist/time);
end

end



