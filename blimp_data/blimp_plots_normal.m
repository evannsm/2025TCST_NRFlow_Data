% clc;clear;close all
run('set_variables.m')

% Loop for calling the plotting functions
for i = 1:8
    disp(i)
    NR = NR_dict{i, 2};
    MPC = MPC_dict{i, 2};
    FBL = FBL_dict{i, 2};

    % Original names without underscores
    names = {strrep(NR(10:end-4), '_', ' '), strrep(MPC(10:end-4), '_', ' '), strrep(FBL(10:end-4), '_', ' ')};
    
    % Create a mapping from abbreviations to full descriptions
    mapping = containers.Map({'CH', 'CV', 'F8H', 'F8VS', 'F8VT', 'HX'}, ...
                             {'Horizontal Circle', 'Vertical Circle', 'Horizontal Lemniscate', 'Vert Short Lemniscate', 'Vert Tall Lemniscate', 'Helix'});
    
    % Iterate through the names and replace the abbreviation with full descriptions
    for j = 1:length(names)
        % Split the name by space
        name_parts = strsplit(names{j}, ' ');
        
        % Replace the second part based on the mapping
        if isKey(mapping, name_parts{2})
            % If 'SPN' exists, insert 'Spinning' in between controller and trajectory
            if any(contains(name_parts, 'SPN'))
                names{j} = [name_parts{1}, ' Spinning ', mapping(name_parts{2})];
            else
                names{j} = [name_parts{1}, ': ', mapping(name_parts{2})];
            end
        end
    end
    
    % Display the updated names
    disp(names);


    NR_log_file_path = fullfile(data_path, NR);
    MPC_log_file_path = fullfile(data_path, MPC);
    FBL_log_file_path = fullfile(data_path, FBL);
    
    NR_df_log = load_log_data(NR_log_file_path);
    MPC_df_log = load_log_data(MPC_log_file_path);
    FBL_df_log = load_log_data(FBL_log_file_path);

    if i <= 5
        if contains(NR, 'CH') || contains(NR, 'F8H')
            plot_together(names, NR_df_log, MPC_df_log, FBL_df_log, 'xy', i, gca);
        elseif contains(NR, 'CV') || contains(NR, 'F8VS') || contains(NR, 'F8VT')
            plot_together(names, NR_df_log, MPC_df_log, FBL_df_log, 'xz', i, gca);
        end
%     elseif i == 6
%         plot_together_HX(names, NR_df_log, MPC_df_log, FBL_df_log);
%     elseif i == 7
%         plot_together_CH_SPIN(names, NR_df_log, MPC_df_log, FBL_df_log);
%     elseif i == 8
%         plot_together_HX_SPIN(names, NR_df_log, MPC_df_log, FBL_df_log);
    end
end




% Function to load log data
function data = load_log_data(filepath)
    data = readtable(filepath);
end