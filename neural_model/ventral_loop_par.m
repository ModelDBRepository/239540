genType2=[0.2  0.2             ...str2gpi, str2gpe (2 paths)  
          0.15  0.1  0.1  0.1    ...stn2gpi, stn2gpe gpe2stn gpe2gpi
          0.13   0.1  0.12 0.015   ...gpi2thal thal2crx crxl1_2crxl2 crxl2_2crxl1
          0.1  0.03  0.35        ...crx2thal crx2str crx2stn
          0.2   0.2  0.45 0      ...baselines: strd1 strd2 stn gpi 
          0     0.3  0    0      ...baselines: gpe thal crx1 crx2
          0.2   0.7  0.6  0.25]; ...epsilon and lambda, strd1, strd2 
par_vec2 = param_scale(genType2);


decay2  = ones(1,8)*300;                            %strd1 strd2 stn gpe gpi thal crx1 crx2
noise2  = [0   0     0   0   0   0.3   0.4   0.3];  %strd1 strd2 stn gpe gpi thal crx1 crx2
th_out2 = [0.2 0.2   0   0   0   0.3   0.6   0.2];  %strd1 strd2 stn gpe gpi thal crx1 crx2
eps_lam2= [par_vec2.strd1_eps par_vec2.strd1_lam    %strd1
           par_vec2.strd2_eps par_vec2.strd2_lam    %strd2
           1 0; 1 0; 1 0; 1 0; 1 0; 1 0];           %stn gpe gpi thal crx1 crx2