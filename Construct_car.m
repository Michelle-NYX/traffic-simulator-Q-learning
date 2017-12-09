function car = Construct_car(pos_x, pos_y, vel_x, vel_y, accel, lane_id)

% Construct structure of a single car
% pos_y = {0, 3.6}

setGlobal;

car.x = pos_x;
car.theta = pos_x / Params.road_radius;
car.y = pos_y;
car.vx = vel_x;
car.vy = vel_y;
car.a = accel;
car.lane_id = lane_id;