clc; clear; close all;
run('set_variables.m')

figure; % Single figure with a 2x6 layout

% Load data for each block
for i = 1:3
    NR = NR_dict_HS{i, 2};
    MPC = MPC_dict_HS{i, 2};

    % Original names without underscores
    names = {strrep(NR(11:end-4), '_', ' '), strrep(MPC(1:end-4), '_', ' ')};
    names(1) = strrep(names(1), 'quad', 'NR');
    names(2) = names(2);
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
    disp(names);

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

sgtitle('Compact 2x6 Layout Comparison for Overleaf'); % Title for the whole figure

% Function to load log data
function data = load_log_data(filepath)
    data = readtable(filepath);
end

% Function to plot data for each block
function plot_data_section(block_idx, names, NR_df, MPC_df, is_chs)
    % Time filtering for NR and MPC
    nrcutoff = 12;
    mpccutoff = 7;
    NR_time_filter = (NR_df.time > nrcutoff) & (NR_df.time < (NR_df.time(end) - nrcutoff));  % After first 10 seconds, before last 10 seconds
    MPC_time_filter = (MPC_df.time > mpccutoff) & (MPC_df.time < (MPC_df.time(end) - mpccutoff));  % After first 5 seconds, before last 5 seconds

    % Apply the time filters to the data
    NR_df = NR_df(NR_time_filter, :);
    MPC_df = MPC_df(MPC_time_filter, :);


    % Assign subplot indices based on 2x6 layout
    % NR plots in subplots 1-6 and MPC in subplots 7-12
    base_idx_NR = (block_idx - 1) * 2 + 1;
    base_idx_MPC = base_idx_NR + 6;

    if is_chs
        % CHS-specific layout with x vs y and yaw vs time plots
        subplot(2, 6, base_idx_NR); % x vs y NR
        plot(NR_df.x, NR_df.y, 'r'); hold on;
        plot(NR_df.x_ref, NR_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['x vs y ', names{1}]);
        legend('NR', 'NR ref');

        subplot(2, 6, base_idx_NR + 1); % yaw vs time NR
        plot(NR_df.time, NR_df.yaw, 'r'); hold on;
        plot(NR_df.time, NR_df.yaw_ref, '--b');
        xlabel('Time (s)'); ylabel('Yaw (rad)');
        title(['Yaw vs time ', names{1}]);
        legend('NR', 'NR ref');

        subplot(2, 6, base_idx_MPC); % x vs y MPC
        plot(MPC_df.x, MPC_df.y, 'r'); hold on;
        plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['x vs y ', names{2}]);
        legend('MPC', 'MPC ref');

        subplot(2, 6, base_idx_MPC + 1); % yaw vs time MPC
        plot(MPC_df.time, MPC_df.yaw, 'r'); hold on;
        plot(MPC_df.time, MPC_df.yaw_ref, '--b');
        xlabel('Time (s)'); ylabel('Yaw (rad)');
        title(['Yaw vs time ', names{2}]);
        legend('MPC', 'MPC ref');
    else
        % Regular layout for Helix and Helix 2x
        subplot(2, 6, base_idx_NR); % y vs x NR
        plot(NR_df.x, NR_df.y, 'r'); hold on;
        plot(NR_df.x_ref, NR_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['y vs x ', names{1}]);
        legend('NR', 'NR ref');

        subplot(2, 6, base_idx_NR + 1); % z vs x NR
        plot(NR_df.x, -NR_df.z, 'r'); hold on;
        plot(NR_df.x_ref, -NR_df.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title(['z vs x ', names{1}]);
        legend('NR', 'NR ref');

        subplot(2, 6, base_idx_MPC); % y vs x MPC
        plot(MPC_df.x, MPC_df.y, 'r'); hold on;
        plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title(['y vs x ', names{2}]);
        legend('MPC', 'MPC ref');

        subplot(2, 6, base_idx_MPC + 1); % z vs x MPC
        plot(MPC_df.x, -MPC_df.z, 'r'); hold on;
        plot(MPC_df.x_ref, -MPC_df.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title(['z vs x ', names{2}]);
        legend('MPC', 'MPC ref');
    end
end
