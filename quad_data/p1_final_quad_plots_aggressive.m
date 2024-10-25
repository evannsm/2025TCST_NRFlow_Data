clc; clear; close all;
run('set_variables.m')

% Create a 2x6 tiled layout with spacing adjustments
figure;
tiledlayout(2, 6, 'TileSpacing', 'compact', 'Padding', 'none'); 
sgtitle('Aggressive Trajectories Part I'); % Title for the whole figure
% Define the x positions for the vertical lines
x = .0041;
y = .0062;
x_positions = [0.33 + x, 0.66 + y]; % Assuming each 2x2 block occupies ~1/3 of the figure width

% Draw vertical bars after each 2x2 block
for x_pos = x_positions
    annotation('line', [x_pos x_pos], [.02 .95], 'Color', 'k', 'LineWidth', 2.5); % Draws a vertical black line
end
% Load data for each block
for i = 1:3
    NR = NR_dict_HS{i, 2};
    MPC = MPC_dict_HS{i, 2};

    % Original names without underscores
    names = {strrep(NR(11:end-4), '_', ' '), strrep(MPC(1:end-4), '_', ' ')};
    names(1) = strrep(names(1), 'quad', 'NR');
    
    % Create a mapping from abbreviations to full descriptions
    mapping = containers.Map({'CH', 'CV', 'F8H', 'F8VS', 'F8VT', 'HX'}, ...
                             {'Horizontal Circle', 'Vertical Circle', 'Horizontal Lemniscate', 'Vert Short Lemniscate', 'Vert Tall Lemniscate', 'Helix'});

    % Replace abbreviations in names
    for j = 1:length(names)
        name_parts = strsplit(names{j}, ' ');
        if isKey(mapping, name_parts{2})
            if any(contains(name_parts, 'SPN'))
                names{j} = [name_parts{1}, ' Spinning ', mapping(name_parts{2})];
            else
                names{j} = [name_parts{1}, ': ', mapping(name_parts{2})];
            end
        end
    end

    % Define file paths
    NR_log_file_path = fullfile(nr_data_path, NR);
    MPC_log_file_path = fullfile(mpc_data_path, MPC);

    % Load data
    NR_df_log = load_log_data(NR_log_file_path);
    MPC_df_log = load_log_data(MPC_log_file_path);

    % Plot data based on block and controller
    if i == 1
        % Block 1 - Helix
        NR_df_log.z = NR_df_log.z + .15;
        MPC_df_log.z = MPC_df_log.z - .15;
        plot_data_section(1, names, NR_df_log, MPC_df_log, false);
    elseif i == 2
        % Block 2 - Helix 2x
        NR_df_log.z = NR_df_log.z + 0.0;
        MPC_df_log.z = MPC_df_log.z - .10;
        plot_data_section(2, names, NR_df_log, MPC_df_log, false);
    elseif i == 3
        % Block 3 - CHS with custom x vs y and yaw layout
        plot_data_section(3, names, NR_df_log, MPC_df_log, true);
    end
end

% Function to load log data
function data = load_log_data(filepath)
    data = readtable(filepath);
end

% Function to plot data for each block
function plot_data_section(block_idx, names, NR_df, MPC_df, is_chs)
    % Apply time filtering for NR and MPC
    nrcutoff = 12;
    mpccutoff = 7;
    NR_time_filter = (NR_df.time > nrcutoff) & (NR_df.time < (NR_df.time(end) - nrcutoff));
    MPC_time_filter = (MPC_df.time > mpccutoff) & (MPC_df.time < (MPC_df.time(end) - mpccutoff));

    % Filter the data
    NR_df = NR_df(NR_time_filter, :);
    MPC_df = MPC_df(MPC_time_filter, :);

    % Assign the tile indices for NR and MPC
    tile_NR = (block_idx - 1) * 2 + 1;
    tile_MPC = tile_NR + 6;

    if is_chs
        % CHS-specific layout with x vs y and yaw vs time plots
        nexttile(tile_NR); % x vs y NR
        plot(NR_df.x, NR_df.y, 'r'); hold on;
        plot(NR_df.x_ref, NR_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['x vs y ', names{1}]);
        legend('NR', 'NR ref');

        nexttile(tile_NR + 1); % yaw vs time NR
        plot(NR_df.time, NR_df.yaw, 'r'); hold on;
        plot(NR_df.time, NR_df.yaw_ref, '--b');
        xlabel('Time (s)'); ylabel('Yaw (rad)');
        title(['Yaw vs time ', names{1}]);
        legend('NR', 'NR ref');

        nexttile(tile_MPC); % x vs y MPC
        plot(MPC_df.x, MPC_df.y, 'r'); hold on;
        plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['x vs y ', names{2}]);
        legend('MPC', 'MPC ref');

        nexttile(tile_MPC + 1); % yaw vs time MPC
        plot(MPC_df.time, MPC_df.yaw, 'r'); hold on;
        plot(MPC_df.time, MPC_df.yaw_ref, '--b');
        xlabel('Time (s)'); ylabel('Yaw (rad)');
        title(['Yaw vs time ', names{2}]);
        legend('MPC', 'MPC ref');
    else
        % Regular layout for Helix and Helix 2x
        nexttile(tile_NR); % y vs x NR
        plot(NR_df.x, NR_df.y, 'r'); hold on;
        plot(NR_df.x_ref, NR_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['y vs x ', names{1}]);
        legend('NR', 'NR ref');

        nexttile(tile_NR + 1); % z vs x NR
        plot(NR_df.x, -NR_df.z, 'r'); hold on;
        plot(NR_df.x_ref, -NR_df.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title(['z vs x ', names{1}]);
        legend('NR', 'NR ref');

        nexttile(tile_MPC); % y vs x MPC
        plot(MPC_df.x, MPC_df.y, 'r'); hold on;
        plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['y vs x ', names{2}]);
        legend('MPC', 'MPC ref');

        nexttile(tile_MPC + 1); % z vs x MPC
        plot(MPC_df.x, -MPC_df.z, 'r'); hold on;
        plot(MPC_df.x_ref, -MPC_df.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title(['z vs x ', names{2}]);
        legend('MPC', 'MPC ref');
    end
end
