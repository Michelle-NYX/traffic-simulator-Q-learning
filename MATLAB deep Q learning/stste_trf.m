function temp=stste_trf(state)
message=state2msg(state);
fields = fieldnames(message);
for i = 1:length(fields)
   temp(i) = message.(fields{i});
   
end
temp=temp';
end