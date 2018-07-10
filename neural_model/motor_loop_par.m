genType1=[0.2  0.2             ...str2gpi, str2gpe (2 paths)  
          0.15  0.1  0.1  0.1    ...stn2gpi, stn2gpe gpe2stn gpe2gpi
          0.13   0.1  0.12 0.015   ...gpi2thal thal2crx crxl1_2crxl2 crxl2_2crxl1
          0.1  0.03  0.35        ...crx2thal crx2str crx2stn
          0.2   0.2  0.45 0      ...baselines: strd1 strd2 stn gpi 
          0     0.3  0    0      ...baselines: gpe thal crx1 crx2
          0.2   0.7  0.6  0.25]; ...epsilon and lambda, strd1, strd2 
par_vec1 = param_scale(genType1);


decay1  = ones(1,8)*300;                            %strd1 strd2 stn gpe gpi thal crx1 crx2
noise1  = [0   0     0   0   0   0.3   0.4   0.3];    %strd1 strd2 stn gpe gpi thal crx1 crx2
th_out1 = [0.2 0.2   0   0   0   0.3   0.6   0.2];    %strd1 strd2 stn gpe gpi thal crx1 crx2
eps_lam1= [par_vec1.strd1_eps par_vec1.strd1_lam    %strd1
           par_vec1.strd2_eps par_vec1.strd2_lam    %strd2
           1 0; 1 0; 1 0; 1 0; 1 0; 1 0];           %stn gpe gpi thal crx1 crx2


% %%optimised Sci Rep:
% genType1=[0.3 0.3            ...str2gpi, str2gpe (2 paths)  
%          0.15 0.05 0.1 0.3 ...stn2gpi, stn2gpe gpe2stn gpe2gpi
%          0.1 0.1 0.12 0.00  ...gpi2thal thal2crx crxl1_2crxl2 crxl2_2crxl1
%          0.1 0.1 0.35       ...crx2thal crx2str crx2stn
%          0.2 0.2 0.35   0   ...baselines: strd1 strd2 stn(x2) gpi 
%          0   0.15   0   0    ...baselines: gpe thal(x2) crx1 crx2
%          0.2 0.5 0.6 0.25]; ...epsilon and lambda, strd1, strd2 
% par_vec1 = param_scale(genType1);
% 
% decay1  = ones(1,8)*300;        %strd1 strd2 stn gpe gpi thal crx1 crx2
% noise1  = [0   0     0   0   0   0   0.5   0.5];  %strd1 strd2 stn gpe gpi thal crx1 crx2
% th_out1 = [0.3 0.3   0   0   0   0 .6 0.2];        %strd1 strd2 stn gpe gpi thal crx1 crx2
% eps_lam1= [par_vec1.strd1_eps par_vec1.strd1_lam    %strd1
%            par_vec1.strd2_eps par_vec1.strd2_lam    %strd2
%            1 0; 1 0; 1 0; 1 0; 1 0; 1 0];           %stn gpe gpi thal crx1 crx2




% % % optimised ADHD
% genType1=[0.17 0.1            ...str2gpi, str2gpe (2 paths)  
%           0.14 0.05 0.1  0.05 ...stn2gpi, stn2gpe gpe2stn gpe2gpi
%           0.1 0.1  0.12 0.00  ...gpi2thal thal2crx crxl1_2crxl2 crxl2_2crxl1
%           0.08 0.07 0.35       ...crx2thal crx2str crx2stn
%           0.2  0.2  0.45 0   ...baselines: strd1 strd2 stn gpi 
%           0    0.4  0    0    ...baselines: gpe thal crx1 crx2
%           0.6  0.1  0.6  0.3]; ...epsilon and lambda, strd1, strd2 
% par_vec1 = param_scale(genType1);
% 
% decay1  = ones(1,8)*60;        %strd1 strd2 stn gpe gpi thal crx1 crx2
% noise1  = [0   0     0   0   0   0  0.3 0.3];  %strd1 strd2 stn gpe gpi thal crx1(0.8) crx2
% th_out1 = [0.3 0.3   0   0   0   0   .45 0.2];        %strd1 strd2 stn gpe gpi thal crx1 crx2
% eps_lam1= [par_vec1.strd1_eps par_vec1.strd1_lam    %strd1
%            par_vec1.strd2_eps par_vec1.strd2_lam    %strd2
%            1 0; 1 0; 1 0; 1 0; 1 0; 1 0];           %stn gpe gpi thal crx1 crx2
