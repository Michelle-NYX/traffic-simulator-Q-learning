function plot_score(score, episode, collision_flag, epsilon)
if score ~= 0
    if collision_flag == true
        plot(episode, score, '.r');
    else
        plot(episode, score, '.b');
    end
end
hold on;

if episode == 1
    xlabel('episode');
    ylabel('score');
end

legend(['eps = ' num2str(epsilon)]);
drawnow;

end