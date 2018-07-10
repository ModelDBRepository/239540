function output = bg_loop_init(T, dim, parameters, decay_vec, noise_vec, th_vec, el_mat)

structure.strd1.potential = zeros(T,dim);
structure.strd1.activity  = zeros(T,dim);
structure.strd2.potential = zeros(T,dim);
structure.strd2.activity  = zeros(T,dim);
structure.stn.potential   = zeros(T,dim);
structure.stn.activity    = zeros(T,dim);
structure.gpi.potential   = zeros(T,dim);
structure.gpi.activity    = zeros(T,dim);
structure.gpe.potential   = zeros(T,dim);
structure.gpe.activity    = zeros(T,dim);
structure.thal.potential  = zeros(T,dim);
structure.thal.activity   = zeros(T,dim);
structure.crx1.potential  = zeros(T,dim);
structure.crx1.activity   = zeros(T,dim);
structure.crx2.potential  = zeros(T,dim);
structure.crx2.activity   = zeros(T,dim);

%matrix of lateral connections used in all layers
structure.strd1.self_w=zeros(dim);
structure.strd2.self_w=zeros(dim);
structure.stn.self_w  =zeros(dim);
structure.gpi.self_w  =zeros(dim);
structure.gpe.self_w  =zeros(dim);
structure.thal.self_w =zeros(dim);
structure.crx1.self_w =zeros(dim);
structure.crx2.self_w =zeros(dim);

%decay used for all units
structure.strd1.decay =decay_vec(1);
structure.strd2.decay =decay_vec(2);
structure.stn.decay   =decay_vec(3);
structure.gpi.decay   =decay_vec(4);
structure.gpe.decay   =decay_vec(5);
structure.thal.decay  =decay_vec(6);
structure.crx1.decay  =decay_vec(7);
structure.crx2.decay  =decay_vec(8);

%noise activation per layer
structure.strd1.noise =noise_vec(1);            %if noise=1 -> bl=bl+-0.1
structure.strd2.noise =noise_vec(2);
structure.stn.noise   =noise_vec(3);
structure.gpi.noise   =noise_vec(4);
structure.gpe.noise   =noise_vec(5);
structure.thal.noise  =noise_vec(6);
structure.crx1.noise  =noise_vec(7);
structure.crx2.noise  =noise_vec(8);

%matrix of connections among layers
structure.str2gpi =eye(dim)*parameters.str2gpi_par + (ones(dim)-eye(dim))*parameters.str2gpi_all;
structure.str2gpe =eye(dim)*parameters.str2gpe_par + (ones(dim)-eye(dim))*parameters.str2gpe_all;
structure.stn2gpe =eye(dim)*parameters.stn2gpe_par + (ones(dim)-eye(dim))*parameters.stn2gpe_all;
structure.stn2gpi =eye(dim)*parameters.stn2gpi_par + (ones(dim)-eye(dim))*parameters.stn2gpi_all;
structure.gpe2stn =eye(dim)*parameters.gpe2stn_par + (ones(dim)-eye(dim))*parameters.gpe2stn_all;
structure.gpe2gpi =eye(dim)*parameters.gpe2gpi_par + (ones(dim)-eye(dim))*parameters.gpe2gpi_all;
structure.gpi2thal=eye(dim)*parameters.gpi2thal_par+ (ones(dim)-eye(dim))*parameters.gpi2thal_all;
structure.thal2crx=eye(dim)*parameters.thal2crx_par+ (ones(dim)-eye(dim))*parameters.thal2crx_all;
structure.crx2str =eye(dim)*parameters.crx2str_par + (ones(dim)-eye(dim))*parameters.crx2str_all;
structure.crx2stn =eye(dim)*parameters.crx2stn_par + (ones(dim)-eye(dim))*parameters.crx2stn_all;
structure.crx2thal=eye(dim)*parameters.crx2thal_par+ (ones(dim)-eye(dim))*parameters.crx2thal_all;
structure.crxl1_2crxl2=eye(dim)*parameters.crxl1_2crxl2_par+ (ones(dim)-eye(dim))*parameters.crxl1_2crxl2_all;
structure.crxl2_2crxl1=eye(dim)*parameters.crxl2_2crxl1_par+ (ones(dim)-eye(dim))*parameters.crxl2_2crxl1_all;

%baselines per layer
structure.strd1.baseline =parameters.strd1_bl;
structure.strd2.baseline =parameters.strd2_bl;
structure.stn.baseline =parameters.stn_bl;
structure.gpe.baseline =parameters.gpe_bl;
structure.gpi.baseline =parameters.gpi_bl;
structure.thal.baseline=parameters.thal_bl;
structure.crx1.baseline =parameters.crx1_bl;
structure.crx2.baseline =parameters.crx2_bl;

%thresholds per layer
structure.strd1.th_out  =th_vec(1);
structure.strd2.th_out  =th_vec(2);
structure.stn.th_out    =th_vec(3);
structure.gpe.th_out    =th_vec(4);
structure.gpi.th_out    =th_vec(5);
structure.thal.th_out   =th_vec(6);
structure.crx1.th_out   =th_vec(7);
structure.crx2.th_out   =th_vec(8);

%dopamine parameter per structure
structure.strd1.epsilon   =el_mat(1,1);     % if =0 the input is not processed without dopamine
structure.strd1.lambda    =el_mat(1,2);      % if =0 dopamine has no effect
structure.strd2.epsilon   =el_mat(2,1);     % if =0 the input is not processed without dopamine
structure.strd2.lambda    =el_mat(2,2);      % if =0 dopamine has no effect
structure.stn.epsilon     =el_mat(3,1);
structure.stn.lambda      =el_mat(3,2);
structure.gpe.epsilon     =el_mat(4,1);
structure.gpe.lambda      =el_mat(4,2);
structure.gpi.epsilon     =el_mat(5,1);
structure.gpi.lambda      =el_mat(5,2);
structure.thal.epsilon    =el_mat(6,1);
structure.thal.lambda     =el_mat(6,2);
structure.crx1.epsilon    =el_mat(7,1);
structure.crx1.lambda     =el_mat(7,2);
structure.crx2.epsilon    =el_mat(8,1);
structure.crx2.lambda     =el_mat(8,2);

output=structure;