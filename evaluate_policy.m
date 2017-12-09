% NYX 12/07/17

function [Colli_rate, Performance, Lane_change_times] =  ...
    evaluate_policy(Policy_1, plot_flag, if_saving_gif, ...
                    simu_times, simulate_horizon, min_car_num, max_car_num)

setGlobal;
Colli_rate = zeros(max_car_num - min_car_num + 1, 1);
Performance = zeros(max_car_num - min_car_num + 1, 1);
Lane_change_times = zeros(max_car_num - min_car_num + 1, 1);

for num_cars = min_car_num: max_car_num
    
    fprintf('\nCar Number: %d\n', num_cars);
    
    performance = 0;   
    tot_colli = 0;
    bad_init = 0;
    lane_change_times = 0;
    
    for episode = 1 : simu_times
        
        if mod(episode,100) == 0
            fprintf('\nSimulating episode: %d\n', episode);
        end
        
        [output, ~, if_bad_init] = simulate(num_cars, simulate_horizon, Policy_1, plot_flag, Params, if_saving_gif);    
        
        if ~if_bad_init
            tot_colli = tot_colli + output(2);
        end
        
        if ~if_bad_init && ~output(2)
            performance = performance + output(1) / simulate_horizon;
            lane_change_times = lane_change_times + output(3);
        end
        
        % save gif
%         if output(3) >= 1 && plot_flag && ~output(2) && if_saving_gif
%             filename = ['simulation_animation_' num2str(tic) '_num_cars_' num2str(num_cars)... 
%                 '_ln_change_' num2str(output(3)) '.gif'];
%             for i = 1:length(frames)
%                 im = frame2im(frames(i));
%                 [imind,cm] = rgb2ind(im,256);
%                 % Write to the GIF File
%                 cd Animation
%                 if i == 1
%                     imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%                 else
%                     imwrite(imind,cm,filename,'gif','WriteMode','append');
%                 end
%                 cd ..
%             end
%         end
        
        % count bad initialization
        if if_bad_init
            bad_init = bad_init + 1;
        end
        
        if plot_flag == true
            close all;
        end
        
    end %simulation for simu_times
    
    Colli_rate(num_cars - min_car_num + 1) = tot_colli / (simu_times - bad_init);
    Performance(num_cars - min_car_num + 1) = performance/...
        (simu_times - bad_init - tot_colli);
    Lane_change_times(num_cars - min_car_num + 1) = lane_change_times/...
        (simu_times - bad_init - tot_colli);
end



