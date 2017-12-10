function collision_flag = check_collision(Cars, Params)
for car_id = 1:length(Cars)
    obs_of_all_cars(car_id) = get_Observation(car_id, Cars, Params);
    % check collision
    if is_collision(obs_of_all_cars(car_id), Params)
        collision_flag = true;
        break;
    else
        collision_flag = false;
    end
end
return