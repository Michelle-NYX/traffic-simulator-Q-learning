function state = deep_obs2state()
% input: observation for a single car,
%        struct of a car which ususally be the ego_car
% output: state id (1~1458)
setGlobal;
% NYX modified 12/01/2017 13:28;
ego_obs=evalin('base', 'ego_obs');
obs=ego_obs;
msg = obs2msg(obs, Params);
state = msg2state(msg);
% state=stste_trf(ego_obs);






