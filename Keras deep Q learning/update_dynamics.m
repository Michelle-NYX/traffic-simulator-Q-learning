function [Cars, dist, ego_action] = update_dynamics(Cars, dist, Params)
dt = Params.time_step;

% get current observation of each car
for car_id = 1:length(Cars)
    obs_of_all_cars(car_id) = get_Observation(car_id, Cars, Params);
end

% update position: x and y
for car_id = 1:length(Cars)
    
    if car_id ~= 1 % env car action selection
        action_id = policy_0(obs_of_all_cars(car_id), Params);
        
        if action_id ~= 7
%             acc = Params.actions(action_id);
            dynamics = act2dyn(action_id, Params);
            acc = dynamics(1);
            Cars(car_id).vy = dynamics(2);
        elseif action_id == 7 % collision
            acc = - Cars(car_id).vx / dt * 0.85; % ???????
            Cars(car_id).vy = 0;
        end
    else % ego car action selection
        
        % need change to reinforcement learning
        % e.g. action_id = policy_1(obs_of_all_cars(car_id));
        
        action_id = policy_0(obs_of_all_cars(car_id), Params);
        ego_action = action_id;
        
        if action_id ~= 7
            dynamics = act2dyn(action_id, Params);
            acc = dynamics(1);
            Cars(car_id).vy = dynamics(2);
        elseif action_id == 7 % collision
            acc = - Cars(car_id).vx / dt * 0.85; % ???????
            Cars(car_id).vy = 0;
        end
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
    Cars(car_id).x = Cars(car_id).x + Cars(car_id).vx * dt;
    if Cars(car_id).lane_id == 1
        Cars(car_id).y = Cars(car_id).y + Cars(car_id).vy * dt;
    else
        Cars(car_id).y = Cars(car_id).y - Cars(car_id).vy * dt;
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


