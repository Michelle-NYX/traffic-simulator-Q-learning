% Set Public Global Params
% DO NOT MODIFY THESE VALUES UNLESS ANNOUNCED IN GROUPS!!!

% NYX modified 12/01/2017 17:08;

global Params;

% Define traffic dynamics
Params.nominal_speed = 25;
Params.min_speed = 20;
Params.max_speed = 30;

Params.num_env_cars = 25;

% Define action consts
Params.accel_mild = 2.5;
Params.decel_mild = -2.5;
Params.accel_hard = 4;
Params.decel_hard = -4;
Params.lat_vel = 3.6; % lane change time = 1s


Params.carlength = 6;
Params.carwidth = 2;
Params.lanewidth = 3.6;

Params.safe_dist = 6;

Params.max_sight_distance = 100;
Params.close_distance = 20;
Params.far_distance = 40;

Params.time_step = 1;
Params.horizon = 200;
Params.road_length = 500;
Params.road_radius = Params.road_length / 2 / pi;