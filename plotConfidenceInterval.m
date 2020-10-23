function [] = plotConfidenceInterval(average, error)
    figure();
    % prepare it for the fill function
    x_ax    = 1:numel(average);
    X_plot  = [x_ax, fliplr(x_ax)];
    Y_plot  = [average-1.96.*error, fliplr(average+1.96.*error)];

    % plot a line + confidence bands
    hold on 
    plot(x_ax, average, 'blue', 'LineWidth', 1.2)
    fill(X_plot, Y_plot , 1, 'facecolor','blue', 'edgecolor','none', 'facealpha', 0.3);
    hold off
end