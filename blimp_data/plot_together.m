% Function for plotting multiple controllers in a 3-row, 5-column layout
function plot_together(names, NR_df, MPC_df, FBL_df, plane, col, axs)
    % Define labels
    labels = {'a) ', 'b) ', 'c) ', 'd) ', 'e) ', ...
              'f) ', 'g) ', 'h) ', 'i) ', 'j) ', ...
              'k) ', 'l) ', 'm) ', 'n) ', 'o) '};
%     sgtitle("Blimp Trajectories Part I")
    % Column index setup for 3 rows per controller (NR, MPC, FBL)
    if strcmp(plane, 'xy')
        % Plot y vs x for NR
        subplot(3, 5, col);  % First row in the column
        plot(NR_df.x, NR_df.y, 'r'); hold on;
        plot(NR_df.x_ref, NR_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([labels{col}, names{1}]);  % Add label before title
        
        % Plot y vs x for MPC
        subplot(3, 5, 5 + col);  % Second row in the column
        plot(MPC_df.x, MPC_df.y, 'red'); hold on;
        plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([labels{5 + col}, names{2}]);  % Add label before title
        
        % Plot y vs x for FBL
        subplot(3, 5, 10 + col);  % Third row in the column
        plot(FBL_df.x, FBL_df.y, 'red'); hold on;
        plot(FBL_df.x_ref, FBL_df.y_ref, '--b');
        xlabel('x (m)'); ylabel('y (m)');
        title([labels{10 + col}, names{3}]);  % Add label before title
        
    elseif strcmp(plane, 'xz')
        % Plot z vs x for NR
        subplot(3, 5, col);  % First row in the column
        plot(NR_df.x, NR_df.z, 'r'); hold on;
        plot(NR_df.x_ref, NR_df.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title([labels{col}, names{1}]);  % Add label before title
        
        % Plot z vs x for MPC
        subplot(3, 5, 5 + col);  % Second row in the column
        plot(MPC_df.x, MPC_df.z, 'red'); hold on;
        plot(MPC_df.x_ref, MPC_df.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title([labels{5 + col}, names{2}]);  % Add label before title
        
        % Plot z vs x for FBL
        subplot(3, 5, 10 + col);  % Third row in the column
        plot(FBL_df.x, FBL_df.z, 'red'); hold on;
        plot(FBL_df.x_ref, FBL_df.z_ref, '--b');
        xlabel('x (m)'); ylabel('z (m)');
        title([labels{10 + col}, names{3}]);  % Add label before title
    end
end
