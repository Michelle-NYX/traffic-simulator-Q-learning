% lisheng 12/4/17
% This is actually a simulator

function [net_out, score, collision_flag, N,transition_store,ra_store,replay_count,wb_out]= Q_learning(net, num_env_cars, plot_flag, epsilon, gamma, neuron1,B,transition_store,ra_store,replay_count,wb,N,replay_size,net1,episode,policy1)
%%
setGlobal;

%% initialization
% Initizlie and Construct the traffic environment
Cars = simulator_initializaiton(Params, num_env_cars);


time = 0;
dist = 0;
score = 0;

ego_obs = get_Observation(1, Cars, Params);
collision_flag = check_collision(Cars, Params);

if plot_flag
    Plot_Traffics_not_saving_gif(Cars, time, dist, Params, ego_obs);
end

%% Run with dynamics for a given time horizon
% beta version, ego car uses policy 0

for time = 1 : Params.time_step : Params.horizon
    %% update dynamics, with relative coord, i.e. ego_x = 0;
    s = obs2state(ego_obs, Params);
%     R = get_reward(ego_obs, Cars(1), collision_flag, Params);
    
    % update Cars
    [Cars, dist, ego_action] = Q_update_dynamics(Cars, dist, Params, net, epsilon,policy1,episode);
    
    % statistics
    N(s, ego_action) = N(s, ego_action) + 1;
    
    % check if there is collision:
    collision_flag = check_collision(Cars, Params);
    
    % update ego_obs
    % ego_obs of next time step:
    ego_obs = get_Observation(1, Cars, Params);
    R = get_reward(ego_obs, Cars(1), collision_flag, Params);
    
    a = ego_action;
    % update state to next state
    s_n = obs2state(ego_obs, Params);
    
   %% 
    if collision_flag == false
   
        replay_count=replay_count+1;
        %update replay memory
              
        transition_store(:,replay_count,1)=stste_trf(s);
        transition_store(:,replay_count,2)=stste_trf(s_n);
        ra_store(1,replay_count)=R;
        ra_store(2,replay_count)=a;
        if replay_count==replay_size    
        replay_count=0;
        end
  
        if size(ra_store,2)>=B && episode>50 % if replay memory size is larger than mini batch size  
                    
            batch_index=randperm(size(ra_store,2),B);          
            r_p=ra_store(1,batch_index); % reward=1*B
            a_p=ra_store(2,batch_index); % action =1*B
            s_p=transition_store(:,batch_index,1); % mini batch s sample in cloumn
            s_np=transition_store(:,batch_index,2); % mini batch s'
            
            q=net(s_p);% current predicted q(s) in cloumn
            q_n=net1(s_np);
            update_q=r_p+gamma*max(q_n);
        
         
            update_index=sub2ind(size(q),a_p,1:B);
            q(update_index)=update_q; % new q for training
            
            
            %net2 = feedforwardnet([neuron1,neuron2]); %initialize neural network
            net2 = feedforwardnet(neuron1); %initialize neural network
            net2.performFcn = 'mse';
            net2.trainFcn = 'traingdm';
            net2.divideParam.trainRatio = 1;
            net2.divideParam.valRatio = 0;
            net2.divideParam.testRatio = 0;
            net2.trainParam.epochs=1;
            net2.trainParam.showWindow=false;
            net2.layers{1}.transferFcn = 'poslin';
%             net2.layers{2}.transferFcn = 'poslin';
%             net2.layers{3}.transferFcn = 'poslin';
            net2.layers{2}.transferFcn = 'purelin';
                net2 = setwb(net2,wb);
                
            net_out = train(net2,s_p,q); % new neural netwrok      
            
            wb_out=getwb(net_out);
            
        else
             net_out=net;
             wb_out=wb;
        end
        
        
        
        
        
        if plot_flag
            Plot_Traffics_not_saving_gif(Cars, time, dist, Params, ego_obs);
        end
    else
        % filter bad initialization
        if time >= 3
            
           
        replay_count=replay_count+1;
        %update replay memory
              
        transition_store(:,replay_count,1)=stste_trf(s);
        transition_store(:,replay_count,2)=stste_trf(s_n);
        ra_store(1,replay_count)=R;
        ra_store(2,replay_count)=a;
        if replay_count==replay_size    
        replay_count=0;
        end
        if size(ra_store,2)>=B && episode>50 % if replay memory size is larger than mini batch size
            
           
            
            batch_index=randperm(size(ra_store,2),B);          
            r_p=ra_store(1,batch_index); % reward=1*B
            a_p=ra_store(2,batch_index); % action =1*B
            s_p=transition_store(:,batch_index,1); % mini batch s sample in cloumn
            s_np=transition_store(:,batch_index,2); % mini batch s'
            
            q=net(s_p);% current predicted q(s) in cloumn
            q_n=net1(s_np);
            update_q=r_p+gamma*max(q_n);
        
         
            update_index=sub2ind(size(q),a_p,1:B);
            q(update_index)=update_q; % new q for training
            
            
            %net2 = feedforwardnet([neuron1,neuron2]); %initialize neural network
                 net2 = feedforwardnet(neuron1); %initialize neural network
            net2.performFcn = 'mse';
            net2.trainFcn = 'traingdm';
            net2.divideParam.trainRatio = 1;
            net2.divideParam.valRatio = 0;
            net2.divideParam.testRatio = 0;
            net2.trainParam.epochs=1;
            net2.trainParam.showWindow=false;
            net2.layers{1}.transferFcn = 'poslin';
%             net2.layers{2}.transferFcn = 'poslin';
%             net2.layers{3}.transferFcn = 'poslin';
            net2.layers{2}.transferFcn = 'purelin';
                net2 = setwb(net2,wb);
                
            net_out = train(net2,s_p,q); % new neural netwrok      
            
            wb_out=getwb(net_out);
            
        else
             net_out=net;
             wb_out=wb;
        end
            
            
            
            
            
            score = (dist-4000)/1000;
            
            disp('Collision!');
            fprintf('Distance Travelled = %3.4d m\n', dist);
            fprintf('Average Speed      = %3.2f m/s\n', dist/time);
            fprintf('Score              = %3.2f \n', score);
            
            if plot_flag
                Plot_Traffics_not_saving_gif(Cars, time, dist, Params, ego_obs);
            end
        else
             net_out=net;
             wb_out=wb;
            disp('Bad initialization!');
        end
        
        break; % break the current episode & restart simulation
        
    end % collision check
    
end % for time

%%
if collision_flag == false
    score = (dist-4000)/1000;
    disp('No Collision');
    fprintf('Distance Travelled = %3.4d m\n', dist);
    fprintf('Average Speed      = %3.2f m/s\n', dist/time);
    fprintf('Score              = %3.2f \n', score);
end

return



