function state = msg2state(message)

% NYX modified 12/01/2017 17:08;

% consider environment cars (6 params)
num_str = '';
fields = fieldnames(message);
for i = 1:length(fields)-1
   str_temp = num2str(message.(fields{i}) - 1);
   num_str = strcat(num_str,str_temp);
end
id_temp = base2dec(num_str,3); %starting from 0 to NUM_STATES/2 = 728

% consider lane info
if message.lane_id == 1
    state = id_temp;
else
    state = 729 + id_temp;
end

state = state + 1;
