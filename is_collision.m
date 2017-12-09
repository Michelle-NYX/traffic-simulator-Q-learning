function collision_flag = is_collision(obs, Params)
collision_flag = false;

safety_factor = 0.1;

if obs.fc_d <= Params.carlength + Params.safe_dist * safety_factor
    collision_flag = true;
end

return