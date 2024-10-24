% Plot function for 'CH/SPIN' controllers (y vs x and yaw vs time)
function plot_together_CH_SPIN(names, NR_df, MPC_df, FBL_df)
    figure;
    % y vs x
    subplot(3, 2, 1);
    plot(NR_df.x, NR_df.y, 'r'); hold on;
    plot(NR_df.x_ref, NR_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{1}]);
    %legend('NR', 'NR ref');

    subplot(3, 2, 3);
    plot(MPC_df.x, MPC_df.y, 'r'); hold on;
    plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{2}]);
    %legend('MPC', 'MPC ref');

    subplot(3, 2, 5);
    plot(FBL_df.x, FBL_df.y, 'r'); hold on;
    plot(FBL_df.x_ref, FBL_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{3}]);
    %legend('FBL', 'FBL ref');

    % yaw vs time
    subplot(3, 2, 2);
    plot(NR_df.time, NR_df.psi, 'r'); hold on;
    plot(NR_df.time, NR_df.psi_ref, '--b');
    xlabel('time (s)'); ylabel('yaw (rad)');
    title([names{1}, ' Yaw']);
    %legend('NR', 'NR ref');

    subplot(3, 2, 4);
    plot(MPC_df.time, MPC_df.psi, 'r'); hold on;
    plot(MPC_df.time, MPC_df.psi_ref, '--b');
    xlabel('time (s)'); ylabel('yaw (rad)');
    title([names{2}, ' Yaw']);
    %legend('MPC', 'MPC ref');

    subplot(3, 2, 6);
    plot(FBL_df.time, FBL_df.psi, 'r'); hold on;
    plot(FBL_df.time, FBL_df.psi_ref, '--b');
    xlabel('time (s)'); ylabel('yaw (rad)');
    title([names{3}, ' Yaw']);
    %legend('FBL', 'FBL ref');
end