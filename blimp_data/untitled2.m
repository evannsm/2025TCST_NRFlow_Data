% Create a new figure
figure;

% Create a subplot
subplot(2, 2, 1); % First subplot in a 2x2 grid

% Create two axes within the same subplot, side by side
ax1 = axes('Position', [0.1 0.1 0.35 0.8]); % Left side plot
ax2 = axes('Position', [0.55 0.1 0.35 0.8]); % Right side plot

% Plot in the left axes (ax1)
axes(ax1); % Activate the first axes
plot(rand(10,1), rand(10,1)); % Example plot 1
xlabel('X1'); ylabel('Y1');
title('Left Plot');

% Plot in the right axes (ax2)
axes(ax2); % Activate the second axes
plot(rand(10,1), rand(10,1)); % Example plot 2
xlabel('X2'); ylabel('Y2');
title('Right Plot');
