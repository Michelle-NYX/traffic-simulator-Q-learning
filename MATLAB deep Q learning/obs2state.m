function state = obs2state(obs, Params)
% input: observation for a single car,
%        struct of a car which ususally be the ego_car
% output: state id (1~1458)

% NYX modified 12/01/2017 13:28;

msg = obs2msg(obs, Params);
state = msg2state(msg);






