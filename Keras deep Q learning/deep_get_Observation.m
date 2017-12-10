% lisheng 11/27/17

function deep_get_Observation(subject_car_idx)
setGlobal;
% load('Cars.mat','Cars')
Cars=evalin('base', 'Cars');
% convert theta from -pi~pi to 0~2*pi
for i = 1:length(Cars)
    if Cars(i).theta < 0 && Cars(i).theta >= - pi
        Cars(i).theta = Cars(i).theta + 2*pi;
    end
end

subject_car = Cars(subject_car_idx);
all_idces = 1:length(Cars);
other_cars_idces = find(all_idces ~= subject_car_idx);
% make a copy of other_cars
other_cars = Cars(other_cars_idces);
num_other_cars = length(Cars) - 1;


dthetas = zeros(num_other_cars, 1);
other_cars_in_same_lane_idces = [];
other_cars_in_target_lane_idces = [];

for i = 1: num_other_cars
    dthetas(i) = other_cars(i).theta - subject_car.theta;
    if dthetas(i) > pi
        dthetas(i) = dthetas(i) - 2*pi;
    elseif dthetas(i) < - pi
        dthetas(i) = dthetas(i) + 2*pi;
    end
    
    if other_cars(i).lane_id == subject_car.lane_id
        other_cars_in_same_lane_idces = [other_cars_in_same_lane_idces; i];
    else
        other_cars_in_target_lane_idces = [other_cars_in_target_lane_idces; i];
    end
end

% find the three surrounding cars around subject_car
%% 1 - front center
dtheta_same_lane = dthetas(other_cars_in_same_lane_idces);
possible_fc_cars_idces = find(dtheta_same_lane > 0);
fc_dtheta = min(dtheta_same_lane(possible_fc_cars_idces));
if ~isempty(fc_dtheta)
    fc_car_idx = find(dthetas == fc_dtheta);
    fc_car = other_cars(fc_car_idx);
    fc_v = fc_car.vx - subject_car.vx;
    fc_d = fc_dtheta * Params.road_radius;
elseif ~isempty(find(dtheta_same_lane < 0, 1))
    possible_fc_cars_idces = find(dtheta_same_lane < 0);
    fc_dtheta = min(dtheta_same_lane(possible_fc_cars_idces));
    fc_car_idx = find(dthetas == fc_dtheta);
    fc_car = other_cars(fc_car_idx);
    fc_v = fc_car.vx - subject_car.vx;
    fc_d = Params.road_length + fc_dtheta * Params.road_radius;
else
    fc_v = 0;
    fc_d = Params.road_length;
end

%% 2 - front target
dtheta_target_lane = dthetas(other_cars_in_target_lane_idces);
possible_ft_cars_idces = find(dtheta_target_lane > 0);
ft_dtheta = min(dtheta_target_lane(possible_ft_cars_idces));
if ~isempty(ft_dtheta)
    ft_car_idx = find(dthetas == ft_dtheta);
    ft_car = other_cars(ft_car_idx);
    ft_v = ft_car.vx - subject_car.vx;
    ft_d = ft_dtheta * Params.road_radius;
elseif ~isempty(find(dtheta_target_lane < 0, 1))
    possible_ft_cars_idces = find(dtheta_target_lane < 0);
    ft_dtheta = min(dtheta_target_lane(possible_ft_cars_idces));
    ft_car_idx = find(dthetas == ft_dtheta);
    ft_car = other_cars(ft_car_idx);
    ft_v = ft_car.vx - subject_car.vx;
    ft_d = Params.road_length + ft_dtheta * Params.road_radius;
else
    ft_v = 0;
    ft_d = Params.road_length;
end

%% 3 - rear target
dtheta_target_lane = dthetas(other_cars_in_target_lane_idces);
possible_rt_cars_idces = find(dtheta_target_lane < 0);
rt_dtheta = max(dtheta_target_lane(possible_rt_cars_idces));
if ~isempty(rt_dtheta)
    rt_car_idx = find(dthetas == rt_dtheta);
    rt_car = other_cars(rt_car_idx);
    rt_v = rt_car.vx - subject_car.vx;
    rt_d = rt_dtheta * Params.road_radius;
elseif ~isempty(find(dtheta_target_lane > 0, 1))
    possible_rt_cars_idces = find(dtheta_target_lane > 0);
    rt_dtheta = max(dtheta_target_lane(possible_rt_cars_idces));
    rt_car_idx = find(dthetas == rt_dtheta);
    rt_car = other_cars(rt_car_idx);
    rt_v = rt_car.vx - subject_car.vx;
    rt_d = - (Params.road_length - rt_dtheta * Params.road_radius);
else
    rt_v = 0;
    rt_d = - Params.road_length;
end


%% construct obs
lane_id = subject_car.lane_id;
obs = Construct_Observation(fc_d, fc_v, ft_d, ft_v, rt_d, rt_v, lane_id);
ego_obs=obs;
assignin('base', 'ego_obs', ego_obs)
% save('ego_obs.mat','ego_obs')
return

