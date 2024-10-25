clc;clear;close all
run('set_variables.m')

% Loop for calling the plotting functions
for i = 1:3
    disp(i)
    NR = NR_dict_HS{i, 2};
    MPC = MPC_dict_HS{i, 2};

    % Original names without underscores
    names = {strrep(NR(11:end-4), '_', ' '), strrep(MPC(1:end-4), '_', ' ')};
    names(1) = strrep(names(1), 'quad', 'NR');
    names(2) = names(2);
%     disp(names)
    % Create a mapping from abbreviations to full descriptions
    mapping = containers.Map({'CH', 'CV', 'F8H', 'F8VS', 'F8VT', 'HX'}, ...
                             {'Horizontal Circle', 'Vertical Circle', 'Horizontal Lemniscate', 'Vert Short Lemniscate', 'Vert Tall Lemniscate', 'Helix'});
%     disp(names)
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


    NR_log_file_path = fullfile(nr_data_path, NR);
    MPC_log_file_path = fullfile(mpc_data_path, MPC);
    
    NR_df_log = load_log_data(NR_log_file_path);
    MPC_df_log = load_log_data(MPC_log_file_path);

    if i == 1 %edit here
        plot_together_HX(i, names, NR_df_log, MPC_df_log);
    elseif i == 2
        plot_together_HX(i, names, NR_df_log, MPC_df_log);
    elseif i == 3
        plot_together_CH_SPIN(i, names, NR_df_log, MPC_df_log)
    end
end




% Function to load log data
function data = load_log_data(filepath)
    data = readtable(filepath);
end