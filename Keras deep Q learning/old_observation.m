function old_observation()
% load('ego_obs.mat','ego_obs')
ego_obs=evalin('base', 'ego_obs');
ego_obs_t = ego_obs;
% save('ego_obs_t.mat','ego_obs_t')
assignin('base', 'ego_obs_t', ego_obs_t)
end