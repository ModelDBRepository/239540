function par_structure = param_scale(genType)

phenType(1)  = genType(1)*(-10);                % str2gpi parallel
phenType(2)  = genType(2)*(-10);                % str2gpe parallel
phenType(3)  = genType(3)*(+10);                 % stn2gpi all
phenType(4)  = genType(4)*(+10);                 % stn2gpe all
phenType(5)  = genType(5)*(-10);                % gpe2stn parallel
phenType(6)  = genType(6)*(-10);                % gpe2gpi parallel
phenType(7)  = genType(7)*(-10);                % gpi2thal parallel

phenType(8)  = genType(8)*(+10);                % thal2crx parallel
phenType(9)  = genType(9)*(+10);                % crxl1_2crxl2 parallel
phenType(10) = genType(10)*(+10);               % crxl2_2crxl1 parallel
phenType(11) = genType(11)*(+10);               % crx2thal parallel
phenType(12) = genType(12)*(+10);               % crx2str parallel
phenType(13) = genType(13)*(+10);               % crx2stn parallel

phenType(14) = genType(14)*(+1);                % strd1.baseline
phenType(15) = genType(15)*(+1);                % strd2.baseline
phenType(16) = genType(16)*(+2);                % stn.baseline
phenType(17) = genType(17)*(+1);                % gpi.baseline
phenType(18) = genType(18)*(+1);                % gpe.baseline
phenType(19) = genType(19)*(+2);                % thal.baseline
phenType(20) = genType(20)*(+1);                % crx1.baseline
phenType(21) = genType(21)*(+1);                % crx2.baseline

phenType(22) = genType(22)*(+1);                % strd1.epsilon
phenType(23) = genType(23)*(+2);                % strd1.lambda

phenType(24) = genType(24)*(+1);                % strd2.epsilon
phenType(25) = genType(25)*(-2);                % strd2.lambda

parameters.str2gpi_par  = phenType(1);
parameters.str2gpi_all  = 0;
parameters.str2gpe_par  = phenType(2);
parameters.str2gpe_all  = 0;
parameters.stn2gpi_par  = phenType(3); %par=all forced
parameters.stn2gpi_all  = phenType(3); %par=all forced
parameters.stn2gpe_par  = phenType(4); %par=all forced
parameters.stn2gpe_all  = phenType(4); %par=all forced
parameters.gpe2stn_par  = phenType(5);
parameters.gpe2stn_all  = 0;
parameters.gpe2gpi_par  = phenType(6);
parameters.gpe2gpi_all  = 0;
parameters.gpi2thal_par = phenType(7);
parameters.gpi2thal_all = 0;

parameters.thal2crx_par = phenType(8);
parameters.thal2crx_all = 0;
parameters.crxl1_2crxl2_par = phenType(9);
parameters.crxl1_2crxl2_all = 0;
parameters.crxl2_2crxl1_par = phenType(10);
parameters.crxl2_2crxl1_all = 0;
parameters.crx2thal_par = phenType(11);
parameters.crx2thal_all = 0;
parameters.crx2str_par  = phenType(12);
parameters.crx2str_all  = 0;
parameters.crx2stn_par  = phenType(13);
parameters.crx2stn_all  = 0;

parameters.strd1_bl     = phenType(14);
parameters.strd2_bl     = phenType(15);
parameters.stn_bl       = phenType(16);
parameters.gpi_bl       = phenType(17);
parameters.gpe_bl       = phenType(18);
parameters.thal_bl      = phenType(19);
parameters.crx1_bl      = phenType(20);
parameters.crx2_bl      = phenType(21);

parameters.strd1_eps    = phenType(22);
parameters.strd1_lam    = phenType(23);
parameters.strd2_eps    = phenType(24);
parameters.strd2_lam    = phenType(25);

par_structure = parameters;