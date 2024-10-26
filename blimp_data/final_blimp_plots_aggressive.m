% clc; clear; close all;
data_path = 'z_hardware_evanns_logs/';

% Define dictionaries with aggressive trajectory files for each controller
FBL_dict_aggressive = {'1', 'official_FBL_HX.log'; '1', 'official_FBL_CH_SPN.log'; '2', 'official_FBL_HX_SPN.log'};
MPC_dict_aggressive = {'1', 'official_NMPC_HX.log'; '2', 'official_NMPC_CH_SPN3.log'; '3', 'official_NMPC_HX_SPN.log'};
NR_dict_aggressive = {'1', 'official_NR_HX.log'; '2', 'official_NR_CH_SPN3.log'; '3', 'official_NR_HX_SPN.log'};

% Load log data for each controller and trajectory type
NR_HX_log = load_log_data(fullfile(data_path, NR_dict_aggressive{1, 2}));
NR_CHS_log = load_log_data(fullfile(data_path, NR_dict_aggressive{2, 2}));
NR_HXS_log = load_log_data(fullfile(data_path, NR_dict_aggressive{3, 2}));

MPC_HX_log = load_log_data(fullfile(data_path, MPC_dict_aggressive{1, 2}));
MPC_CHS_log = load_log_data(fullfile(data_path, MPC_dict_aggressive{2, 2}));
MPC_HXS_log = load_log_data(fullfile(data_path, MPC_dict_aggressive{3, 2}));

FBL_HX_log = load_log_data(fullfile(data_path, FBL_dict_aggressive{1, 2}));
FBL_CHS_log = load_log_data(fullfile(data_path, FBL_dict_aggressive{2, 2}));
FBL_HXS_log = load_log_data(fullfile(data_path, FBL_dict_aggressive{3, 2}));

% Create a 3x7 tiled layout with compact spacing
figure;
tiledlayout(3, 7, 'TileSpacing', 'compact', 'Padding', 'none');
% sgtitle('Blimp= Aggressive Trajectories Comparison'); % Title for the whole figure

% Define the x positions for the black vertical lines to separate blocks
black_bar_positions = [0.288, 0.575];

% Add black bars to separate the blocks
for x_pos = black_bar_positions
    annotation('line', [x_pos x_pos], [0.00 1.00], 'Color', 'k', 'LineWidth', 1.8);
end

% Define plot titles
titles = {'Helix Horz (Y v X)', 'Helix Vert (Z v X)', 'Spin Circle (Y v X)', ...
          'Yaw (Yaw v Time)', 'Spin Helix Horz (Y v X)', 'Spin Helix Vert (Z v X)', 'Yaw (Yaw v Time)'};

% Alphabet label for each subplot
alphabet = 'abcdefghijklmnopqrstuvwxyz';

% Plot for each controller and trajectory type
label_index = 1; % Start counter for subplot labeling
for i = 1:3  % Rows: NR, MPC, FBL
    for j = 1:7  % Columns: Each trajectory type
        nexttile
        % Determine the appropriate log data and title prefix based on the row
        switch i
            case 1
                log_data = eval(['NR_', get_log_name(j), '_log']);
                title_prefix = 'NR: ';
            case 2
                log_data = eval(['MPC_', get_log_name(j), '_log']);
                title_prefix = 'MPC: ';
            case 3
                log_data = eval(['FBL_', get_log_name(j), '_log']);
                title_prefix = 'FBL: ';
        end
        hold on;

        % Choose the correct data to plot based on column j
        switch j
            case {1, 3, 5} % Y v X plots
                plot(log_data.x, log_data.y, 'b'); % Actual path
                plot(log_data.x_ref, log_data.y_ref, 'r--'); % Reference path
            case {2, 6} % Z v X plots
                plot(log_data.x, log_data.z, 'b'); % Actual path
                plot(log_data.x_ref, log_data.z_ref, 'r--'); % Reference path
            case {4, 7} % Yaw v time
                plot(log_data.time, log_data.psi, 'b'); % Actual yaw
                plot(log_data.time, log_data.psi_ref, 'r--'); % Reference yaw
        end

        % Set title with letter label, appropriate prefix, and labels for each plot
        title([alphabet(label_index), ') ', title_prefix, titles{j}]);
        xlabel(get_xlabel(j));
        ylabel(get_ylabel(j));
        
        % Increment label index for the next subplot
        label_index = label_index + 1;
        
        hold off;
    end
end

% Function to get the log variable name based on column index
function name = get_log_name(index)
    switch index
        case {1, 2}
            name = 'HX';
        case {3, 4}
            name = 'CHS';
        case {5, 6, 7}
            name = 'HXS';
    end
end

% Function to get x-axis label based on plot type
function label = get_xlabel(index)
    if ismember(index, [1, 2, 3, 5, 6])
        label = 'X';
    elseif ismember(index, [4, 7])
        label = 'time';
    end
end

% Function to get y-axis label based on plot type
function label = get_ylabel(index)
    if ismember(index, [1, 3, 5])
        label = 'Y';
    elseif ismember(index, [2, 6])
        label = 'Z';
    elseif ismember(index, [4, 7])
        label = 'Yaw';
    end
end

% Function to load log data
function data = load_log_data(filepath)
    data = readtable(filepath);
end
