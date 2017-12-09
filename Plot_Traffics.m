function frame = Plot_Traffics(Cars, time, dist, Params, ego_obs, fig)

% NYX 11/29 12:54

% if time == 0
%     figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%     hold on;
% end

num_Cars = length(Cars);
ego_car = Cars(1);

clf('reset');
hold on;

%% Subplot 1: Plot of a circle of entire traffic
subplot(2,1,1)

R_const = 10; %scaling the plot
%Plot the lane markers
thetas = linspace(0, 2*pi);

R1 = (R_const+1.8)/2/pi; %outer circle-->right lane boundary
R2 = (R_const-1.8)/2/pi; %marker at the center of two lanes
R3 = (R_const-5.4)/2/pi; %inner circle-->left lane boundary

polarplot(thetas, R1 + 0.*thetas, 'Color',[1 1 0],'LineWidth',4);
hold on;
polarplot(thetas, R2 + 0.*thetas, 'w--','LineWidth', 3);   
polarplot(thetas, R3 + 0.*thetas, 'Color',[1 1 0],'LineWidth',4);

box on;
ax = gca;
ax.Color = [0.75 0.75 0.75];
grid off;
ax.RTick = [];

%Plot the ego car
% dist = 0; %<--this adjusts whether the ego car moves with the traffic around the circle, or fixed at 0
radius_ego = (R_const - ego_car.y)/2/pi; % scaled
theta_ego = mod(dist, Params.road_length) / Params.road_length * 2*pi;
polarplot(theta_ego, radius_ego, 'rs', 'MarkerFaceColor','r');

%Plot the environment cars
for i = 2:num_Cars
    radius_car = (R_const - Cars(i).y)/2/pi; %scaled
    theta_car = ((Cars(i).x + dist) / Params.road_length) * 2*pi;
    polarplot(theta_car, radius_car, 'bs','MarkerFaceColor','b')
end

%% Subplot 2: Plot of linear lanes --> zoom in plot
subplot(2,1,2)

%Plot the lane markers
thetas = dist-40:dist+120;
plot(thetas, -1.8 + 0.*thetas, 'Color',[1 1 0],'LineWidth',4)
hold on
plot(thetas, 1.8 + 0.*thetas, 'w--','LineWidth',3)       
plot(thetas, 5.4 + 0.*thetas, 'Color',[1 1 0],'LineWidth',4)

axis([dist-40,dist+120, -10,20])
set(gca,'fontsize',36)
box on
ax = gca;
ax.Color = [0.75 0.75 0.75];

% Plot the annotation boxes on the top of the figure--ego
annotation('textbox',...
[0.1 0.85 0.2 0.08],...
'String',{['v_x = ' num2str(ego_car.vx) ' m/s']},...
'FontSize',32,...
'FontName','Arial',...
'LineStyle','-',...
'EdgeColor',[0.85 0.85 0.85],...
'LineWidth',2,...
'BackgroundColor',[0.95  0.95 0.95],...
'Color',[0.84 0.16 0]);

annotation('textbox',...
[0.7 0.85 0.2 0.08],...
'String',{['a_x = ' num2str(ego_car.a) ' m/s^2']},...
'FontSize',32,...
'FontName','Arial',...
'LineStyle','-',...
'EdgeColor',[0.85 0.85 0.85],...
'LineWidth',2,...
'BackgroundColor',[0.95  0.95 0.95],...
'Color',[0.84 0.16 0]);

annotation('textbox',...
[0.1 0.6 0.2 0.08],...
'String',{['time = ' num2str(time) ' s']},...
'FontSize',32,...
'FontName','Arial',...
'LineStyle','-',...
'EdgeColor',[0.85 0.85 0.85],...
'LineWidth',2,...
'BackgroundColor',[0.95  0.95 0.95],...
'Color',[0.84 0.16 0]);

annotation('textbox',...
[0.7 0.6 0.2 0.08],...
'String',{['ego fc dist = ' num2str(round(ego_obs.fc_d)) ' m']},...
'FontSize',32,...
'FontName','Arial',...
'LineStyle','-',...
'EdgeColor',[0.85 0.85 0.85],...
'LineWidth',2,...
'BackgroundColor',[0.95  0.95 0.95],...
'Color',[0.84 0.16 0]);


%Plot the ego car
pos_shift = [-Params.carlength/2, -Params.carwidth/2, Params.carlength, Params.carwidth];
rectangle('position', [ego_car.x + dist, ego_car.y, 0, 0] + pos_shift, 'FaceColor', 'r');

%Plot the surrounded car
for i = 2:num_Cars
     rectangle('position', [Cars(i).x + dist, Cars(i).y, 0, 0] + pos_shift, 'FaceColor', 'b');
end

drawnow;
frame = getframe(fig);


    


