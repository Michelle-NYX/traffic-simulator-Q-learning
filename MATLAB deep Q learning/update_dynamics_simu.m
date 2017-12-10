
function [Cars, dist, ego_action, lane_change_flag] ...
    = update_dynamics_simu(Cars, dist, Policy_1, Params)

dt = Params.time_step;
lane_change_flag = false;

% get current observation of each car
for car_id = 1:length(Cars)
    obs_of_all_cars(car_id) = get_Observation(car_id, Cars, Params);
end

% update position: x and y
for car_id = 1:length(Cars)
    
    if car_id ~= 1 % env car action selection
        action_id = policy_0(obs_of_all_cars(car_id), Params);
        
        if action_id ~= 7
            dynamics = act2dyn(action_id, Params);
            acc = dynamics(1);
            Cars(car_id).vy = dynamics(2);
        elseif action_id == 7 % collision
            acc = - Cars(car_id).vx / dt * 0.85;
            Cars(car_id).vy = 0;
        end
    else % ego car action selection
        
        ego_state = obs2state(obs_of_all_cars(1), Params);
        ego_action = Policy_1(ego_state);
        
        dynamics = act2dyn(ego_action, Params);
        acc = dynamics(1);
        Cars(car_id).vy = dynamics(2);
    end
    
    % update velocity using dynamics
    Cars(car_id).a = acc;
    Cars(car_id).vx = Cars(car_id).vx + acc * dt;
    
    % speed limit
    if Cars(car_id).vx > Params.max_speed
        Cars(car_id).a = 0; % Cars(car_id).a = (Cars(car_id).vx - Params.max_speed)/dt;
        Cars(car_id).vx = Params.max_speed;
    elseif Cars(car_id).vx < Params.min_speed
        Cars(car_id).a = 0;
        Cars(car_id).vx = Params.min_speed;
    end
    
    % update position using dynamics
    % x
    Cars(car_id).x = Cars(car_id).x + Cars(car_id).vx * dt;
    % y, update y and lane_id if vy ~= 0
    if Cars(car_id).vy ~= 0
        lane_change_flag = true;
        if Cars(car_id).lane_id == 1
            Cars(car_id).y = Cars(car_id).y + Cars(car_id).vy * dt;
            Cars(car_id).lane_id = 2;
        else
            Cars(car_id).y = Cars(car_id).y - Cars(car_id).vy * dt;
            Cars(car_id).lane_id = 1;
        end
    end
    
    
    % set relative x - coordinate (wrt ego car)
    Cars(car_id).x  = Cars(car_id).x - Cars(1).vx * dt;
    Cars(car_id).theta = Cars(car_id).x / Params.road_radius;
    
    % re-regulate to -pi~pi
    if Cars(car_id).theta > pi
        Cars(car_id).theta = Cars(car_id).theta - 2*pi;
    elseif Cars(car_id).theta < -pi
        Cars(car_id).theta = Cars(car_id).theta + 2*pi;
    end
    
    Cars(car_id).x = Cars(car_id).theta * Params.road_radius;
    
    % calculate the distance ego car has travelled
    if car_id == 1
        dist = dist + Cars(car_id).vx * dt;
    end
end % update position: x and y

return


