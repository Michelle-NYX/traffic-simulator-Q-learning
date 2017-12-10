function env_ini(num_env_cars)
setGlobal;
Cars = simulator_initializaiton(Params, num_env_cars);
assignin('base', 'Cars', Cars)


% save('Cars.mat','Cars');
end