clc; clear; close all;
run('set_variables.m')

% Create a 2x5 tiled layout with spacing adjustments
figure;
tiledlayout(2, 5, 'TileSpacing', 'compact', 'Padding', 'none'); 
% sgtitle('Aggressive Trajectories Part II'); % Title for the whole figure

% Define the x positions for the vertical lines
x = .0041;
y = .0062;
x_positions = [0.4 + x, 0.8 + y];

% Draw vertical bars after each block
for x_pos = x_positions
    annotation('line', [x_pos x_pos], [.00 1.00], 'Color', 'k', 'LineWidth', 1.8);
end

% Plot each block according to the layout specified
for i = 1:3
    NR = NR_victory_lap_HS{i, 2};
    
    % Extract and format the name for the title
    name = {strrep(NR(11:end-4), '_', ' ')};
    name = strrep(name, 'quad', 'NR');
    disp(name)
    % Create a mapping from abbreviations to full descriptions
    mapping = containers.Map({'CH', 'CV', 'F8H', 'F8VS', 'F8VT', '2x', 'HELIX'}, ...
                             {'Horizontal Circle', 'Vertical Circle', 'Horizontal Lemniscate', 'Vert Short Lemniscate', 'Vert Tall Lemniscate', '2x', 'Helix'});

    % Replace abbreviations in name
    for j = 1:length(name)
        name_parts = strsplit(name{j}, ' ');
%         disp('here')
%         disp(name_parts)
        if isKey(mapping, name_parts{2})
            if any(contains(name_parts, 'SPN'))
                name{j} = [name_parts{1}, ': ', ' Spinning ', mapping(name_parts{2})];
            else
                name{j} = [name_parts{1}, ': ', mapping(name_parts{2})];
            end
            if any(contains(name_parts, '2x'))
                name{j} = [name_parts{1}, ': ', mapping(name_parts{2}), ' Double Speed'];
            end
        end
    end

    disp('here')
    disp(name)
    for k = 1:length(name)

        name_parts = strsplit(name{k}, ' ');
        disp('loop')
        disp(name_parts)
        if any(contains(name_parts, 'CHS'))
            name{k} = [name_parts{1}, ': ',' Spin Circle'];
        end

    end
    disp('done')
    disp(name)
    % Load the NR log file data
    NR_log_file_path = fullfile(nr_data_path, NR);
    NR_df_log = load_log_data(NR_log_file_path);

    % Apply time filtering to remove transient segments
    nrcutoff = 12;
    NR_time_filter = (NR_df_log.time > nrcutoff) & (NR_df_log.time < (NR_df_log.time(end) - nrcutoff));
    NR_df_log = NR_df_log(NR_time_filter, :);

    if i == 1
        % Block 1 (Helix Spin) layout
        % Top row
        nexttile(1); % y vs x
        plot(NR_df_log.x, NR_df_log.y, 'r'); hold on;
        plot(NR_df_log.x_ref, NR_df_log.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([name{1}, ' (Y v X)']);
        legend('NR', 'NR ref');

        nexttile(2); % z vs x
        plot(NR_df_log.x, -NR_df_log.z, 'r'); hold on;
        plot(NR_df_log.x_ref, -NR_df_log.z_ref - .15, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title([name{1}, ' (Z v X)']);
        legend('NR', 'NR ref');

        % Bottom row
        nexttile(6); % yaw vs time
        plot(NR_df_log.time, NR_df_log.yaw, 'r'); hold on;
        plot(NR_df_log.time, NR_df_log.yaw_ref, '--b');
        xlabel('Time (s)'); ylabel('Yaw (rad)');
        title([name{1}, ' (Yaw v Time)']);
        legend('NR', 'NR ref');

    elseif i == 2
        % Block 2 (Helix Spin 2x) layout
        % Top row
        nexttile(3); % y vs x
        plot(NR_df_log.x, NR_df_log.y, 'r'); hold on;
        plot(NR_df_log.x_ref, NR_df_log.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([name{1}, ' (Y v X)']);
        legend('NR', 'NR ref');

        nexttile(4); % z vs x
        plot(NR_df_log.x, -NR_df_log.z, 'r'); hold on;
        plot(NR_df_log.x_ref, -NR_df_log.z_ref - .15, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title([name{1}, ' (Z vs X)']);
        legend('NR', 'NR ref');

        % Bottom row
        nexttile(8); % yaw vs time
        plot(NR_df_log.time, NR_df_log.yaw, 'r'); hold on;
        plot(NR_df_log.time, NR_df_log.yaw_ref, '--b');
        xlabel('Time (s)'); ylabel('Yaw (rad)');
        title([name{1}, ' (Yaw vs time)']);
        legend('NR', 'NR ref');

    elseif i == 3
        % Block 3 (CHS) layout
        % Top row
        nexttile(5); % y vs x
        plot(NR_df_log.x, NR_df_log.y, 'r'); hold on;
        plot(NR_df_log.x_ref, NR_df_log.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([name{1}, ' Horz (Y v X)']);
        legend('NR', 'NR ref');

        % Bottom row
        nexttile(10); % yaw vs time
        plot(NR_df_log.time, NR_df_log.yaw, 'r'); hold on;
        plot(NR_df_log.time, NR_df_log.yaw_ref, '--b');
        xlabel('Time (s)'); ylabel('Yaw (rad)');
        title([name{1}, ' (Yaw vs Time)']);
        legend('NR', 'NR ref');
    end
end

% Function to load log data
function data = load_log_data(filepath)
    data = readtable(filepath);
end
