function action_id = policy_0(obs, Params)

% NYX 11/25/19:09
% lisheng 11/27/17

action_id = 3; % maintain_id

% vert hard deceleration to avoid collision
if obs.fc_d < Params.carlength + Params.safe_dist
    action_id = 7;
    return
end

if obs.fc_d <= Params.close_distance && obs.fc_v < 0
    action_id = 5; % decel_hard_id
    return
end

if obs.fc_d > Params.close_distance && obs.fc_d <= Params.far_distance
    action_id = 4; % decel_mild_id
    return
end

if obs.fc_d > Params.far_distance && obs.fc_v > 0
    action_id = 2; % accel_mild_id
    return
end

%% Action Dictionary

% accel_hard_id = 1;
% accel_mild_id = 2;
% maintain_id   = 3;
% decel_mild_id = 4;
% decel_hard_id = 5;
% lane_change   = 6;
% Define action consts
%            1    2   3     4   5    6    7
% actions = [4; 2.5;  0; -2.5; -4; 3.6]; stop

