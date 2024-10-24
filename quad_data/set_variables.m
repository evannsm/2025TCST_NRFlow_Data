% Define paths for NR and MPC data
nr_data_path = 'all_nr/';
mpc_data_path = 'all_mpc/';

NR_dict_normal = {'1', 'nr_comp_0_quad_CH.log'; 
             '2', 'nr_comp_0_quad_CV.log'; 
             '3', 'nr_comp_0_quad_F8H.log'; 
             '4', 'nr_comp_0_quad_F8VS.log'; 
             '5', 'nr_comp_0_quad_F8VT.log'; 
             '6', 'nr_comp_0_quad_triangle.log'; 
             '7', 'nr_comp_0_quad_sawtooth.log'};

NR_dict_fast = {'1', 'nr_comp_0_quad_CH_2x.log'; 
             '2', 'nr_comp_0_quad_CV_2x.log'; 
             '3', 'nr_comp_0_quad_F8H_2x.log'; 
             '4', 'nr_comp_0_quad_F8VS_2x.log'; 
             '5', 'nr_comp_0_quad_F8VT_2x.log'; 
             '6', 'nr_comp_0_quad_triangle_2x.log'; 
             '7', 'nr_comp_0_quad_sawtooth_2x.log'};

NR_dict_HS = {'1', 'nr_comp_0_quad_HELIX.log'; 
             '2', 'nr_comp_0_quad_HELIX_2x.log'; 
             '3', 'nr_comp_0_quad_HELIX_SPIN.log'; 
             '4', 'nr_comp_0_quad_HELIX_SPIN_2x_circonly.log'; 
             '5', 'nr_comp_0_quad_CHS.log'; 
             '6', 'nr_comp_0_quad_CHS_2x_circonly.log'; 
             '7', 'nr_comp_0_quad_CHS_2x_circyaw.log'};

MPC_dict_normal = {'1', 'mpc_CH.log'; 
              '2', 'mpc_CV.log'; 
              '3', 'mpc_F8H.log'; 
              '4', 'mpc_F8VS.log'; 
              '5', 'mpc_F8VT.log'; 
              '6', 'mpc_triangle.log'; 
              '7', 'mpc_sawtooth.log'};

MPC_dict_fast = {'1', 'mpc_CH_2x.log'; 
              '2', 'mpc_CV_2x.log'; 
              '3', 'mpc_F8H_2x.log'; 
              '4', 'mpc_F8VS_2x.log'; 
              '5', 'mpc_F8VT_2x.log'; 
              '6', 'mpc_triangle_2x.log'; 
              '7', 'mpc_sawtooth_2x.log'};


MPC_dict_HS = {'1', 'mpc_HELIX.log'; 
              '2', 'mpc_HELIX_2x.log'; 
              '3', 'mpc_CHS.log'};
