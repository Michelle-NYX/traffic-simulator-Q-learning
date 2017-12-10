function obs = Construct_Observation(fc_d, fc_v, ft_d, ft_v, rt_d, rt_v, lane_id)
obs.fc_d = fc_d; % front center distance
obs.fc_v = fc_v; % front center velocity
obs.ft_d = ft_d; % front target
obs.ft_v = ft_v;
obs.rt_d = rt_d; % rear target
obs.rt_v = rt_v;
obs.lane_id = lane_id;