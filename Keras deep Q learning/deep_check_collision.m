function collision_flag = deep_check_collision()
setGlobal;
% load('Cars.mat','Cars')
Cars=evalin('base', 'Cars');
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