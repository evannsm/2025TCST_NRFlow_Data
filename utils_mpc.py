import matplotlib.pyplot as plt
import numpy as np

def adjust_data(df, clip = True):
    """Adjusts Data by cutting off the hover transient first and then applying the 0.8s lookahead"""
    actual_values = df[['x', 'y', 'z', 'yaw']].to_numpy()
    reference_values = df[['x_ref', 'y_ref', 'z_ref', 'yaw_ref']].to_numpy()
    time_values = df['time'].to_numpy()

    beginning = 0
    end = -1

    if clip:
        # Part 1: Adjust the data for the hover transient cutoff
        xrefs = reference_values[:,0]
        yrefs = reference_values[:,1]
        traj_startx = np.where(xrefs != 0)[0]
        traj_starty = np.where(yrefs != 0)[0]

        if traj_startx.size == 0:
            beginning = traj_starty[0]
            end = traj_starty[-1]

        elif traj_starty.size == 0:
            beginning = traj_startx[0]
            end = traj_startx[-1]

        else:
            beginning = traj_starty[0] if traj_starty[0] < traj_startx[0] else traj_startx[0]
            end = traj_starty[-1] if traj_starty[-1] > traj_startx[-1] else traj_startx[-1]

    # Slice the actual and reference data based on the hover cutoff
    actual_values = actual_values[beginning:end]
    reference_values = reference_values[beginning:end]
    time_values = time_values[beginning:end]

    # print(actual_values.shape, reference_values.shape)

    # Part 2: Adjust the data for the lookahead time
    adjusted_actuals = []
    adjusted_refs = []
    lookahead_seconds = 3.0  # Desired lookahead time

    # Loop through each time step
    for i, current_time in enumerate(time_values):
        # Find the index where the time is 0.8 seconds ahead
        future_index = np.where(time_values >= current_time + lookahead_seconds)[0]
        if len(future_index) > 0:
            future_index = future_index[0]
            
            # Save the actual and corresponding reference values
            adjusted_actuals.append(actual_values[future_index])
            adjusted_refs.append(reference_values[i])

    # Convert the lists to numpy arrays
    adjusted_actuals = np.array(adjusted_actuals)
    adjusted_refs = np.array(adjusted_refs)
    plot_time = np.linspace(0,30, len(adjusted_actuals))
    
    return adjusted_actuals, adjusted_refs, plot_time



def rmse(df, clip):
    adjusted_actuals, adjusted_refs, _  = adjust_data(df, clip)

    # Scale yaw (assumed this is needed)
    adjusted_actuals[:, 3] *= 0.18
    adjusted_refs[:, 3] *= 0.18

    # Compute the squared differences
    squared_errors = (adjusted_actuals - adjusted_refs) ** 2
    rmse = np.sqrt(np.sum(squared_errors, axis=1).mean())
    return rmse

def make_plot(df, clip):
    fig, axs = plt.subplots(4, 4, figsize=(20, 12), sharex=False)
    time_max = df['time'].max()
    time_min = df['time'].min()
    x_lim = (time_min-1, time_max+1)
    
    actual_data, ref_data, plot_time = adjust_data(df, clip)

    # Row 1: Plot x, y, z, psi vs references
    axs[0, 0].plot(plot_time, actual_data[:,0], label='x', color='red')
    axs[0, 0].plot(plot_time, ref_data[:,0], label='x_ref', color='blue', linestyle='--')
    axs[0, 0].set_ylabel('x / x_ref')
    axs[0, 0].set_xlabel('time')
    axs[0, 0].legend()

    axs[0, 1].plot(plot_time, actual_data[:,1], label='y', color='red')
    axs[0, 1].plot(plot_time, ref_data[:,1], label='y_ref', color='blue', linestyle='--')
    axs[0, 1].set_ylabel('y / y_ref')
    axs[0, 1].set_xlabel('time')
    axs[0, 1].legend()

    axs[0, 2].plot(plot_time, -actual_data[:,2], label='z', color='red')
    axs[0, 2].plot(plot_time, -ref_data[:,2], label='z_ref', color='blue', linestyle='--')
    axs[0, 2].set_ylabel('z / z_ref')
    axs[0, 2].set_xlabel('time')
    axs[0, 2].legend()

    yaw = np.where(ref_data[:,3] == 0, 0, actual_data[:,3])
    axs[0, 3].plot(plot_time, yaw, label='yaw', color='red')
    axs[0, 3].plot(plot_time, ref_data[:,3], label='yaw_ref', color='blue', linestyle='--')
    axs[0, 3].set_ylabel('yaw / yaw_ref')
    axs[0, 3].set_xlabel('time')
    axs[0, 3].legend()



    # Row 2: Plot cross comparisons (x vs y, x vs z, y vs z, time vs solve_time)
    # plot x vs y and x_ref vs y_ref
    destime = -1
    axs[1, 0].plot(actual_data[:,0], actual_data[:,1], label='x vs y', color='red')
    axs[1, 0].plot(ref_data[:,0], ref_data[:,1], label='x_ref vs y_ref', color='blue', linestyle='--')
    axs[1, 0].set_ylabel('y')
    axs[1, 0].set_xlabel('x')
    axs[1, 0].legend()

    # plot x vs z and x_ref vs z_ref
    axs[1, 1].plot(actual_data[:,0], -actual_data[:,2], label='x vs z', color='red')
    axs[1, 1].plot(ref_data[:,0], -ref_data[:,2], label='x_ref vs z_ref', color='blue', linestyle='--')
    axs[1, 1].set_ylabel('z')
    axs[1, 1].set_xlabel('x')
    axs[1, 1].set_ylim(0,-1*df['z'].min()+.1)
    axs[1, 1].legend()

    # plot y vs z and y_ref vs z_ref
    axs[1, 2].plot(actual_data[:,1], -actual_data[:,2], label='y vs z', color='red')
    axs[1, 2].plot(ref_data[:,1], -ref_data[:,2], label='y_ref vs z_ref', color='blue', linestyle='--')
    axs[1, 2].set_ylabel('z')
    axs[1, 2].set_xlabel('y')
    axs[1, 2].set_ylim(0,-1*df['z'].min()+.1)
    axs[1, 2].legend()



# Row 3: Plot throttle, and roll/pitch/yaw-rates vs time

    max_throttle = 1.0
    max_rate = 0.8
    ylim_throttle = (-0.2, 1.2)
    ylim_rates = (-1.0, 1.0)

    # plot throttle vs time
    axs[2, 0].plot(df['time'], -1*df['throttle'], label='throttle', color='blue')
    axs[2, 0].axhline(y=max_throttle, color='red', linestyle='--', label=f'+{max_throttle}')
    axs[2, 0].axhline(y=0, color='red', linestyle='--', label=f'{0}')
    axs[2, 0].set_ylabel('throttle')
    axs[2, 0].set_xlabel('time')
    axs[2, 0].legend()
    axs[2, 0].set_ylim(ylim_throttle)
    axs[2, 0].set_xlim(x_lim)
    axs[2, 0].set_yticks(np.arange(ylim_throttle[0], ylim_throttle[1] + 0.1, 0.2))


    # plot roll_rate vs time
    axs[2, 1].plot(df['time'], df['roll_rate'], label='roll_rate', color='orange')
    axs[2, 1].axhline(y=max_rate, color='red', linestyle='--', label=f'+{max_rate}')
    axs[2, 1].axhline(y=-max_rate, color='red', linestyle='--', label=f'-{max_rate}')
    axs[2, 1].set_ylabel('roll_rate')
    axs[2, 1].set_xlabel('time')
    axs[2, 1].legend()
    axs[2, 1].set_ylim(ylim_rates)
    axs[2, 1].set_xlim(x_lim)
    axs[2, 1].set_yticks(np.arange(ylim_rates[0], ylim_rates[1] + 0.1, 0.2))


    # plot pitch_rate vs time
    axs[2, 2].plot(df['time'], df['pitch_rate'], label='pitch_rate', color='green')
    axs[2, 2].axhline(y=max_rate, color='red', linestyle='--', label=f'+{max_rate}')
    axs[2, 2].axhline(y=-max_rate, color='red', linestyle='--', label=f'-{max_rate}')
    axs[2, 2].set_ylabel('pitch_rate')
    axs[2, 2].set_xlabel('time')
    axs[2, 2].legend()
    axs[2, 2].set_ylim(ylim_rates)
    axs[2, 2].set_xlim(x_lim)
    axs[2, 2].set_yticks(np.arange(ylim_rates[0], ylim_rates[1] + 0.1, 0.2))

    # plot yaw_rate vs time
    axs[2, 3].plot(df['time'], df['yaw_rate'], label='yaw_rate', color='purple')
    axs[2, 3].axhline(y=max_rate, color='red', linestyle='--', label=f'+{max_rate}')
    axs[2, 3].axhline(y=-max_rate, color='red', linestyle='--', label=f'-{max_rate}')
    axs[2, 3].set_ylabel('yaw_rate')
    axs[2, 3].set_xlabel('time')
    axs[2, 3].legend()
    axs[2, 3].set_ylim(ylim_rates)
    axs[2, 3].set_xlim(x_lim)
    axs[2, 3].set_yticks(np.arange(ylim_rates[0], ylim_rates[1] + 0.1, 0.2))

    # Row 4: plot pred_time * mpc_time vs time
    # plot mpc_time vs time
    axs[3, 0].plot(df['time'][1:], df['mpc_time'][1:], label='mpc_time', color='orange')
    axs[3, 0].set_ylabel('mpc_time')
    axs[3, 0].set_xlabel('time')
    axs[3, 0].legend()
    axs[3, 0].set_xlim(x_lim)    


    plt.pause(.001)
    plt.tight_layout()
