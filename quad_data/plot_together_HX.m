% Plot function for 'HX' type controllers (y vs x and z vs x)
function plot_together_HX(i, names, NR_df, MPC_df, FBL_df)
    % Time filtering for NR and MPC
    nrcutoff = 1;
    mpccutoff = 2;
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

    % z vs x
    subplot(2, 2, 2);
    plot(NR_df.x, NR_df.z, 'r'); hold on;
    plot(NR_df.x_ref, NR_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title(['z vs x ', names{1}]);
    legend('NR', 'NR ref');

    subplot(2, 2, 4);
    plot(MPC_df.x, MPC_df.z, 'r'); hold on;
    plot(MPC_df.x_ref, MPC_df.z_ref, '--b');
    xlabel('x (m)'); ylabel('z (m)');
    title(['z vs x ', names{2}]);
    legend('MPC', 'MPC ref');

    if i == 1 || i == 3 || i == 5
        sgtitle('HX Comparison');
    else
        sgtitle('HX 2x Speed Comparison');
    end
end