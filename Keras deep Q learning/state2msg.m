function message = state2msg(state)

% NYX modified 12/01/2017 17:08;

% d: near-->1, midium--> 2, far-->3;
% v: closer-->1, miduium-->2, away-->3;
% lane_id: y==0 (right, outer)-->1, y==3.6 (left, inner) -->2;

if state > 1458
    error('Unknown state.');
end
% initialize state struct
message.fc_d = 2;
message.fc_v = 2;
message.ft_d = 2;
message.ft_v = 2;
message.rt_d = 2;
message.rt_v = 2;
message.lane_id = 1;

id_temp = state - 1;

if id_temp < 729
    message.lane_id = 1;
    
else
    message.lane_id = 2;
    id_temp = id_temp - 729;
end

str = dec2base(id_temp,3);
while length(str) < 6
    str = strcat('0',str);
end

message.fc_d = str2double(str(1))+1;
message.fc_v = str2double(str(2))+1;
message.ft_d = str2double(str(3))+1;
message.ft_v = str2double(str(4))+1;
message.rt_d = str2double(str(5))+1;
message.rt_v = str2double(str(6))+1;  
    