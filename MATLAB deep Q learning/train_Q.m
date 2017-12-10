
function net_out=train_Q(setting_str, episode_limit, time_limit, plot_flag,...
    epsilon, if_eps_decay, decay_rate, gamma,policy1)


net_update=50;
replay_size=100000;

B=32; %mini batch size
neuron1=8; % # neuron


n_statev=7; % state variable
n_action=6; % action space

s_i=randi(7,n_statev,B); % configure input size
q_i=rand(n_action,B);% configure output size
transition_store=zeros(n_statev,1,2);% first layer s second layer s'
ra_store=zeros(2,1); % first row reward second row action
replay_count=0;

% net = feedforwardnet([neuron1,neuron2]); %initialize neural network
net = feedforwardnet(neuron1); %initialize neural network
net = configure(net,s_i,q_i); %initialize neural network
net.performFcn = 'mse';
net.trainFcn = 'traingdm';
net.divideParam.trainRatio = 1;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;
net.trainParam.epochs=1;
net.trainParam.showWindow=false;
net.layers{1}.transferFcn = 'poslin';
% net.layers{2}.transferFcn = 'poslin';
% net.layers{3}.transferFcn = 'poslin';
net.layers{2}.transferFcn = 'purelin';

wb=getwb(net);

net1=net;
net_update_counter=0;
net_out=net;
wb_out=wb;




max_states_num = 3^6 * 2;
action_num = 6;

N = zeros(max_states_num, action_num);
score = zeros(episode_limit, 1);

K = 9/decay_rate ;

start_time = tic;
for episode = 1 : episode_limit

    % epsilon anealing
    if if_eps_decay && episode>2000 && (episode-2000)<=decay_rate
        epsilon = 1 /(1+ K * (episode-2000));
        if episode-2000>decay_rate
            epsilon=0.1;
        end
    end

    fprintf('\nepisode = %d\n', episode);
    disp(epsilon)
    num_env_cars = randi(5) + 20;

    net_in=net_out;
    wb_in=wb_out;
    
    if episode>50
    net_update_counter=net_update_counter+1;
    end
    if net_update_counter==net_update
        net1=net_in;
        net_update_counter=0;
    end
    
    
    [net_out, score(episode), collision_flag, N,transition_store,ra_store,replay_count,wb_out] ...
        = Q_learning(net_in, num_env_cars, plot_flag, epsilon, gamma, neuron1,B,transition_store,ra_store,replay_count,wb_in,N,replay_size,net1,episode,policy1);
    
    
    
    plot_score(score(episode), episode, collision_flag, N);
    
    if mod(episode, 50) == 0
%         cd Parameters
        save net_out
        for i=1:1:3^6*2
            [~,a]=max(net_out(stste_trf(i)));
            policy(i,:)=a;
        end
        csvwrite('Policy_deepQ.csv',policy)
      policy
        csvwrite(['score_' setting_str '.csv'], score);
        csvwrite(['N' setting_str '.csv'], score);
%         cd ..
    end
    
    if toc(start_time) > time_limit
        break;
    end
    
    if plot_flag == true
        close all;
    end
    
end % for episode

% cd Parameters
save net_out

for i=1:1:3^6*2
    [~,a]=max(net_out(stste_trf(i)));
    policy(i,:)=a;
end
policy

csvwrite('Policy_deepQ.csv',policy)

csvwrite(['score_' setting_str '.csv'], score);
csvwrite(['N' setting_str '.csv'], score);
% cd ..



figure;
image(N);
