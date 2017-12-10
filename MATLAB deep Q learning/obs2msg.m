function msg = obs2msg(obs, Params)
% input: observation for a single car;
% output: state-struct correspondes to observation (3 cars: v, d && lane_id)

% NYX modified 12/01/2017 17:08;

%% obs->message transform Description
% d: near-->1, midium--> 2, far-->3;
% v: closer-->1, miduium-->2, away-->3;
% lane_id: y==0 (right, outer)-->1, y==3.6 (left, inner) -->2;

%% processing
% initialization -- maintaining
msg.fc_d = 2;
msg.fc_v = 2;
msg.ft_d = 2;
msg.ft_v = 2;
msg.rt_d = 2;
msg.rt_v = 2;
msg.lane_id = obs.lane_id;

% get fc_d info
if obs.fc_d <= Params.close_distance
    msg.fc_d = 1;
elseif obs.fc_d >= Params.far_distance
        msg.fc_d = 3;
end

% get ft_d info
if obs.ft_d <= Params.close_distance
    msg.ft_d = 1;
elseif obs.ft_d >= Params.far_distance
        msg.ft_d = 3;
end

% get rt_d info %negative
if abs(obs.rt_d) <= Params.close_distance
    msg.rt_d = 1;
elseif abs(obs.rt_d) >= Params.far_distance
        msg.rt_d = 3;
end

%obs.fc_v is defined as: envir.v - ego.v
% get fc_v info
if obs.fc_v < 0
    msg.fc_v = 1;
elseif obs.fc_v > 0
        msg.fc_v = 3;
end

% get ft_v info
if obs.ft_v < 0
    msg.ft_v = 1;
elseif obs.ft_v > 0
        msg.ft_v = 3;
end

% get rt_v info
if obs.rt_v > 0
    msg.rt_v = 1;
elseif obs.rt_v < 0
        msg.rt_v = 3;
end

%% deal with corner cases:
% if front_center_car distance > max_sight, defined as "far" && "moving away"
if obs.fc_d >= Params.max_sight_distance
    msg.fc_d = 3;
    msg.fc_v = 3;
end

if obs.ft_d >= Params.max_sight_distance
    msg.ft_d = 3;
    msg.ft_v = 3;
end

if abs(obs.rt_d) >= Params.max_sight_distance
    msg.rt_d = 3;
    msg.rt_v = 3;
end

