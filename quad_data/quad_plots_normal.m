clc;clear;close all
run('set_variables.m')

% Loop for calling the plotting functions
for i = 1:7
    disp(i)
    NR = NR_dict_normal{i, 2};
    MPC = MPC_dict_normal{i, 2};
    
    % Original names without underscores and replace 'quad' with 'NR' and 'mpc' with 'MPC'
    names = {strrep(strrep(NR(11:end-4), 'quad', 'NR'), '_', ' '), ...
             strrep(strrep(MPC(1:end-4), 'mpc', 'MPC'), '_', ' ')};
        
    % Create a mapping from abbreviations to full descriptions
    mapping = containers.Map({'CH', 'CV', 'F8H', 'F8VS', 'F8VT', 'HX'}, ...
                             {'Horizontal Circle', 'Vertical Circle', 'Horz Lemniscate', 'Vert Short Lemniscate', 'Vert Tall Lemniscate', 'Helix'});
    
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


    nr_cutoff = 12;
    mpc_cutoff = 7;
    if contains(NR, 'CH') || contains(NR, 'F8H')
        plot_together(names, NR_df_log, MPC_df_log, 'xy', i, gca, nr_cutoff, mpc_cutoff);
    elseif contains(NR, 'CV')
        NR_df_log.z = NR_df_log.z - .1;
        MPC_df_log.z = MPC_df_log.z - .1;
        nr_cutoff = 11;
        plot_together(names, NR_df_log, MPC_df_log, 'xz', i, gca, nr_cutoff, mpc_cutoff);
    elseif contains(NR, 'F8VS') || contains(NR, 'F8VT')
        NR_df_log.z = NR_df_log.z - .15;
        MPC_df_log.z = MPC_df_log.z - .15;
        plot_together(names, NR_df_log, MPC_df_log, 'yz', i, gca, nr_cutoff, mpc_cutoff);

    elseif contains(NR, 'triangle') || contains(NR, 'saw')
        nr_cutoff = 5;
        mpc_cutoff = nr_cutoff;
        plot_together(names, NR_df_log, MPC_df_log, 'xy', i, gca, nr_cutoff, mpc_cutoff);
    end
end




% Function to load log data
function data = load_log_data(filepath)
    data = readtable(filepath);
end