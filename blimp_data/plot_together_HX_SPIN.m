% Plot function for 'HX' type controllers (y vs x, z vs x, and yaw vs time)
function plot_together_HX(names, NR_df, MPC_df, FBL_df)
    figure;
    
    % y vs x
    subplot(3, 3, 1);
    plot(NR_df.x, NR_df.y, 'r'); hold on;
    plot(NR_df.x_ref, NR_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{1}, ' Horizontal Segment']);

    subplot(3, 3, 4);
    plot(MPC_df.x, MPC_df.y, 'r'); hold on;
    plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{2}, ' Horizontal Segment']);

    subplot(3, 3, 7);
    plot(FBL_df.x, FBL_df.y, 'r'); hold on;
    plot(FBL_df.x_ref, FBL_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{3}, ' Horizontal Segment']);

    % z vs x
    subplot(3, 3, 2);
    plot(NR_df.x, NR_df.z, 'r'); hold on;
    plot(NR_df.x_ref, NR_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title([names{1}, ' Vertical Segment']);

    subplot(3, 3, 5);
    plot(MPC_df.x, MPC_df.z, 'r'); hold on;
    plot(MPC_df.x_ref, MPC_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title([names{2}, ' Vertical Segment']);

    subplot(3, 3, 8);
    plot(FBL_df.x, FBL_df.z, 'r'); hold on;
    plot(FBL_df.x_ref, FBL_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title([names{3}, ' Vertical Segment']);

    % yaw vs time
    subplot(3, 3, 3);
    plot(NR_df.time, NR_df.psi, 'r'); hold on;
    plot(NR_df.time, NR_df.psi_ref, '--b');
    xlabel('time (s)'); ylabel('yaw (rad)');
    title([names{1}, ' Yaw']);

    subplot(3, 3, 6);
    plot(MPC_df.time, MPC_df.psi, 'r'); hold on;
    plot(MPC_df.time, MPC_df.psi_ref, '--b');
    xlabel('time (s)'); ylabel('yaw (rad)');
    title([names{2}, ' Yaw']);

    subplot(3, 3, 9);
    plot(FBL_df.time, FBL_df.psi, 'r'); hold on;
    plot(FBL_df.time, FBL_df.psi_ref, '--b');
    xlabel('time (s)'); ylabel('yaw (rad)');
    title([names{3}, ' Yaw']);
end
