function plot_score(score, episode, collision_flag, N)


if score ~= 0
   
    if collision_flag == true
       subplot(1,2,1),plot(episode, score, '.r');
    else
       subplot(1,2,1), plot(episode, score, '.b');
    end
end
hold on;

if episode == 1
    xlabel('episode');
    ylabel('score');
    
end

% legend(['eps = ' num2str(epsilon)]);

   subplot(1,2,2), image(N)
    colorbar;
axis square
    drawnow;
end