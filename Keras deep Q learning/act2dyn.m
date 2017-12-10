function dynamics = act2dyn(action, Params)

% NYX modified 12/01/2017 17:08;
% dyn = [a_x, v_y];

% dynamics = [0, 0];
switch action
    case 1
        dynamics = [Params.accel_hard, 0];
        
    case 2
        dynamics = [Params.accel_mild, 0];
        
    case 3
        dynamics = [0, 0];
        
    case 4
        dynamics = [Params.decel_mild, 0];

    case 5
        dynamics = [Params.decel_hard, 0];
    
    case 6
        dynamics = [0, Params.lat_vel];
        
    otherwise
        error('Unknown action.')
end