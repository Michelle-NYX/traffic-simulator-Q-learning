% lisheng 12/05/17

function [colli_rate, performance] =  ...
    evaluate_policy(Policy_1, plot_flag, if_saving_gif, ...
                    simu_times, simulate_horizon, min_car_num, max_car_num)

setGlobal;

tot_colli = 0;
bad_init = 0;
for num_cars = min_car_num: max_car_num
    Performances = zeros(simu_times,1);
    for episode = 1 : simu_times
        
        fprintf('\nSimulating episode: %d\n', episode);
        [output, frames, if_bad_init] = simulate(num_cars, simulate_horizon, Policy_1, plot_flag, Params, if_saving_gif);
        Performances(episode) = output(1);
        tot_colli = tot_colli + output(2);
        fprintf('Lane change times: %d\n', output(3));
        
        % save gif
        if output(3) >= 1 && plot_flag && ~output(2) && if_saving_gif
            filename = ['simulation_animation_' num2str(tic) '_ln_change_' num2str(output(3)) '.gif'];
            for i = 1:length(frames)
                im = frame2im(frames(i));
                [imind,cm] = rgb2ind(im,256);
                % Write to the GIF File
                cd Animation
                if i == 1
                    imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
                else
                    imwrite(imind,cm,filename,'gif','WriteMode','append');
                end
                cd ..
            end
        end
        
        % count bad initialization
        if if_bad_init
            bad_init = bad_init + 1;
        end
        
        if plot_flag == true
            close all;
        end
        
    end
    
    colli_rate = tot_colli / (simu_times - bad_init);
    performance = mean(Performances);
end



