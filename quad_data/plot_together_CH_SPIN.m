% Plot function for 'CH_SPIN' controllers (y vs x and yaw vs time)
function plot_together_CH_SPIN(i, names, NR_df, MPC_df)
    % Time filtering for NR and MPC
    nrcutoff = 12;
    mpccutoff = 7;
    NR_time_filter = (NR_df.time > nrcutoff) & (NR_df.time < (NR_df.time(end) - nrcutoff));  % After first 10 seconds, before last 10 seconds
    MPC_time_filter = (MPC_df.time > mpccutoff) & (MPC_df.time < (MPC_df.time(end) - mpccutoff));  % After first 5 seconds, before last 5 seconds

    % Apply the time filters to the data
    NR_df = NR_df(NR_time_filter, :);
    MPC_df = MPC_df(MPC_time_filter, :);
    figure;
    % y vs x
    subplot(2, 2, 1);
    plot(NR_df.x, NR_df.y, 'r'); hold on;
    plot(NR_df.x_ref, NR_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title(['y vs x ', names{1}]);
    legend('NR', 'NR ref');

    subplot(2, 2, 3);
    plot(MPC_df.x, MPC_df.y, 'r'); hold on;
    plot(MPC_df.x_ref, MPC_df.y_ref, '--b');
    xlabel('x (m)'); ylabel('y (m)');
    title(['y vs x ', names{2}]);
    legend('MPC', 'MPC ref');

    % yaw vs time
    subplot(2, 2, 2);
    plot(NR_df.time, NR_df.yaw, 'r'); hold on;
    plot(NR_df.time, NR_df.yaw_ref, '--b');
    xlabel('Time (s)'); ylabel('Yaw (rad)');
    title(['Yaw vs time ', names{1}]);
    legend('NR', 'NR ref');

    subplot(2, 2, 4);
    plot(MPC_df.time, MPC_df.yaw, 'r'); hold on;
    plot(MPC_df.time, MPC_df.yaw_ref, '--b');
    xlabel('Time (s)'); ylabel('Yaw (rad)');
    title(['Yaw vs time ', names{2}]);
    legend('MPC', 'MPC ref');

    sgtitle('CH SPIN Comparison');
end