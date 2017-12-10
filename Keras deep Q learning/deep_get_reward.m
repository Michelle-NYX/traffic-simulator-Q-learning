function R = deep_get_reward(colli)
setGlobal;
% load('Cars.mat','Cars')
% load('ego_obs_t.mat','ego_obs_t')
Cars=evalin('base', 'Cars');
ego_obs_t=evalin('base', 'ego_obs_t');
obs=ego_obs_t;
ego_car=Cars(1);

msg = obs2msg(obs, Params);
% input: message of the ego car; struct of the ego
% car; a flag of whether the ego car caused a collision --boolean; and Global Params

% output: return a immediate reward r(s,a)

% NYX modified 12/03/2017 16:08;
w1 = 1000; %collision
w2 = 10; %velocity
w3 = 1; %headway
w4 = 1; %effort
w5 = 0.1; %lane --> should be tuned later on

c = - colli; %{-1 if colli, 0 else}
vn = (ego_car.vx - Params.nominal_speed)/5; %scaled velocity \in [-1, 1]
h = 0;
if msg.fc_d == 1
    h = -1;
elseif msg.fc_d == 3
    h = 0.5;
end%{-1 if near, 0 if mid, 0 if far}
l = -(ego_car.lane_id - 1); % {-1 if left, 0 if right}

% a = 0 if maintain; a = -5 if hard_accel or hard_decel; a = -1 if else;
a = -1;
if ego_car.a == 0 && ego_car.vy == 0
    a = 0;
elseif ego_car.a >= Params.accel_hard || ego_car.a <= Params.decel_hard
    a = -5;
end

R = w1*c + w2*vn + w3*h + w4*a + w5*l;

