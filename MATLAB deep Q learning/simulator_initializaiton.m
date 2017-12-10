function Cars = simulator_initializaiton(Params, num_env_cars)

road_radius = Params.road_radius;
car_length = Params.carlength;
safe_dtheta = car_length / road_radius * 1.3;

% Initizlie and Construct the traffic environment
Cars = [];

% first car = ego_car
pos_x = 0;
lane_id = randi(2);
if lane_id == 1
    pos_y = 0;
else
    pos_y = Params.lanewidth;
end
vel_y = 0;
accel = 0;
vel_x = floor(6*rand() + 22) + 1;
ego_car = Construct_car(pos_x, pos_y, vel_x, vel_y, accel, lane_id);
Cars = [ego_car; Cars];


for env_car_id = 1 : num_env_cars
    keep_trying = true;
    while keep_trying
        theta = rand()*2*pi - pi; % [- pi, pi]
        % pos_x: relative to ego
        pos_x = theta * road_radius;
        lane_id = randi(2);
        if lane_id == 1
            pos_y = 0;
        else
            pos_y = Params.lanewidth;
        end
        vel_y = 0;
        accel = 0;
        vel_x = floor(6*rand() + 22) + 1;
        env_car = Construct_car(pos_x, pos_y, vel_x, vel_y, accel, lane_id);
        
        % Only when each existing car in Cars finds the pos is valid, then continue.
        is_pos_valid = true;
        for i = 1:length(Cars)
            existing_car = Cars(i);
%             theta_existing_car = existing_car.x / road_radius;
            dtheta = abs(existing_car.theta - theta);
            if dtheta > pi
                dtheta = 2*pi - dtheta;
            end
            if lane_id == existing_car.lane_id && dtheta < safe_dtheta
                is_pos_valid = false;
            end
        end
        
        if is_pos_valid
            Cars = [Cars; env_car];
            keep_trying = false;
        end
        
    end % while keep_trying
end

return