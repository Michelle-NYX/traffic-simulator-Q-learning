function temp=stste_trf(ego_obs)
fields = fieldnames(ego_obs);
for i = 1:length(fields)
   temp(i) = ego_obs.(fields{i});
end

end