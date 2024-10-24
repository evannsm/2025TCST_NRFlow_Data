% Plot function for 'HX' type controllers (y vs x and z vs x)
function plot_together_HX(names, NR_df, MPC_df, FBL_df)
    figure;
    % y vs x
    subplot(3, 2, 1);
    plot(NR_df.x, NR_df.y, 'r'); hold on;
    plot(NR_df.x_ref, NR_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{1}, ' Horizontal Segment']);
    %legend('NR', 'NR ref');

    subplot(3, 2, 3);
    plot(MPC_df.x, MPC_df.y, 'r'); hold on;
    plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{2}, ' Horizontal Segment']);
    %legend('MPC', 'MPC ref');

    subplot(3, 2, 5);
    plot(FBL_df.x, FBL_df.y, 'r'); hold on;
    plot(FBL_df.x_ref, FBL_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title([names{3}, ' Horizontal Segment']);
    %legend('FBL', 'FBL ref');

    % z vs x
    subplot(3, 2, 2);
    plot(NR_df.x, NR_df.z, 'r'); hold on;
    plot(NR_df.x_ref, NR_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title([names{1}, ' Vertical Segment']);
    %legend('NR', 'NR ref');

    subplot(3, 2, 4);
    plot(MPC_df.x, MPC_df.z, 'r'); hold on;
    plot(MPC_df.x_ref, MPC_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title([names{2} ' Vertical Segment']);
    %legend('MPC', 'MPC ref');

    subplot(3, 2, 6);
    plot(FBL_df.x, FBL_df.z, 'r'); hold on;
    plot(FBL_df.x_ref, FBL_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title([names{3} ' Vertical Segment']);
    %legend('FBL', 'FBL ref');

%     sgtitle('HX Comparison');
end