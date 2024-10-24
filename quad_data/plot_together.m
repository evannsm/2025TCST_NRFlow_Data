% Function for plotting multiple controllers in a 2-row, 7-column layout (NR and MPC only)
function plot_together(names, NR_df, MPC_df, plane, col, axs)
    % Define labels for both rows (NR and MPC)
    labels = {'a) ', 'b) ', 'c) ', 'd) ', 'e) ', 'f) ', 'g) ', ...
              'h) ', 'i) ', 'j) ', 'k) ', 'l) ', 'm) ', 'n) '};

    % Time filtering for NR and MPC
    nrcutoff = 12;
    mpccutoff = 7;
    NR_time_filter = (NR_df.time > nrcutoff) & (NR_df.time < (NR_df.time(end) - nrcutoff));  % After first 10 seconds, before last 10 seconds
    MPC_time_filter = (MPC_df.time > mpccutoff) & (MPC_df.time < (MPC_df.time(end) - mpccutoff));  % After first 5 seconds, before last 5 seconds

    % Apply the time filters to the data
    NR_df_filtered = NR_df(NR_time_filter, :);
    MPC_df_filtered = MPC_df(MPC_time_filter, :);

    % Column index setup for 2 rows per controller (NR and MPC)
    if strcmp(plane, 'xy')
        % Plot y vs x for NR (Filtered data)
        subplot(2, 5, col);  % First row in the column (NR)
        plot(NR_df_filtered.x, NR_df_filtered.y, 'r'); hold on;
        plot(NR_df_filtered.x_ref, NR_df_filtered.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([labels{col}, names{1}]);  % Add label before title for NR
        
        % Plot y vs x for MPC (Filtered data)
        subplot(2, 5, 5 + col);  % Second row in the column (MPC)
        plot(MPC_df_filtered.x, MPC_df_filtered.y, 'red'); hold on;
        plot(MPC_df_filtered.x_ref, MPC_df_filtered.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([labels{5 + col}, names{2}]);  % Add label before title for MPC
        
    elseif strcmp(plane, 'xz')
        % Plot z vs x for NR (Filtered data)
        subplot(2, 5, col);  % First row in the column (NR)
        plot(NR_df_filtered.x, NR_df_filtered.z, 'r'); hold on;
        plot(NR_df_filtered.x_ref, NR_df_filtered.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title([labels{col}, names{1}]);  % Add label before title for NR
        
        % Plot z vs x for MPC (Filtered data)
        subplot(2, 5, 5 + col);  % Second row in the column (MPC)
        plot(MPC_df_filtered.x, MPC_df_filtered.z, 'red'); hold on;
        plot(MPC_df_filtered.x_ref, MPC_df_filtered.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title([labels{5 + col}, names{2}]);  % Add label before title for MPC
        
    elseif strcmp(plane, 'yz')
        % Plot z vs y for NR (Filtered data)
        subplot(2, 5, col);  % First row in the column (NR)
        plot(NR_df_filtered.y, NR_df_filtered.z, 'r'); hold on;
        plot(NR_df_filtered.y_ref, NR_df_filtered.z_ref, '--b');
        xlabel('y (m)'); ylabel('z (m)');
        title([labels{col}, names{1}]);  % Add label before title for NR
        
        % Plot z vs y for MPC (Filtered data)
        subplot(2, 5, 5 + col);  % Second row in the column (MPC)
        plot(MPC_df_filtered.y, MPC_df_filtered.z, 'red'); hold on;
        plot(MPC_df_filtered.y_ref, MPC_df_filtered.z_ref, '--b');
        xlabel('y (m)'); ylabel('z (m)');
        title([labels{5 + col}, names{2}]);  % Add label before title for MPC
    end
end
