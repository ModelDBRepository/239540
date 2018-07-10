clear all
close all

for seed_n=1:30    
%seed_n=2;
rng(seed_n)  %seed 1 used for all 60 mins simulations
stamp_time=0;
time_recordT =0;
time_recordT1=0;
time_recordT2=0;

SECS=60*60;
dt=50;
T=SECS*1000/dt;
dim1=3;             %number of units per layer
dim2=3;

%input and dopamine variability
%load('input_da.mat') %rng(8)
da_baseline = 0.1;    % .2  --  .42  (reduced DA= 0.01)
da_bursts   = 3;
da_tonic    = 1.0;   % .8
input_and_da;

%INTER LOOP connectivity      %0220 - 0317 - 0315 - 0515 - 0713 - 1010 
                              %2002 - 1703 - 1503 - 1505 - 1307 - 1010
ventral2motor_w = eye(3)*.10;
motor2ventral_w = eye(3)*.10;

% condition: 1= control - 2= Habit formation - 3= Risk preference - 
%            4= treatment 1 (motor) - 5= treatment 2 (ventral)
%            6= time for relapse Treatment 1
%            7= time for relapse treatment 2 - 8= test learning effect
for condition=[1] %[1 2 4 5 6 7 8]
tic
   
%initialization
inp_da  = ones(T,1)*da_baseline;

motor_loop_par;
motor_loop = bg_loop_init(T, dim1, par_vec1, decay1, noise1, th_out1, eps_lam1); 

ventral_loop_par;
ventral_loop = bg_loop_init(T, dim2, par_vec2, decay2, noise2, th_out2, eps_lam2); 

da_structure;

t_interv=2000/dt; %ms
min_c=0;
marker1=0;
marker2=0;
marker3=0;
count_act1=0;
count_act2=0;
count_act3=0;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaL=.002; %.03
l_th  =1.0;  %5.0=full - 1.0=partial
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%cortex output control for double output
motor_loop.crx2.self_w=[0 1 1; 1 0 1; 1 1 0]*(-.1);  
ventral_loop.crx2.self_w=[0 1 1; 1 0 1; 1 1 0]*(-.1);  

    %Previous learning
    if condition==6
        ventral_loop.crx2str=[l_th 0 0; 0 .3 0; 0 0 .3];
    elseif condition==7
        motor_loop.crx2str=[l_th 0 0; 0 .3 0; 0 0 .3];        
    elseif condition==8
        ventral_loop.crx2str=[l_th 0 0; 0 .3 0; 0 0 .3];
        motor_loop.crx2str  =[l_th 0 0; 0 .3 0; 0 0 .3];
    end


for t=2:T

    %Previous learning
    if condition==2 && time_recordT==0 && motor_loop.crx2str(1,1)==l_th && ventral_loop.crx2str(1,1)==l_th
        time_recordT=t;
    elseif condition==4
        motor_loop.crx2str  =[0.3  0 0; 0 .3 0; 0 0 .3];          
        ventral_loop.crx2str=[l_th 0 0; 0 .3 0; 0 0 .3];
    elseif condition==5
        motor_loop.crx2str  =[l_th 0 0; 0 .3 0; 0 0 .3];
        ventral_loop.crx2str=[0.3  0 0; 0 .3 0; 0 0 .3];
    elseif condition==6 && time_recordT1==0 && motor_loop.crx2str(1,1)==l_th;    
        time_recordT1=t;
        break
    elseif  condition==7 && time_recordT2==0 && ventral_loop.crx2str(1,1)==l_th;
        time_recordT2=t;    
        break
    end        
    
    %STEP
    motor_cx_input(t,:)=bg_inp{2}(t-1,:) + ventral_loop.crx2.activity(t-1,:)*ventral2motor_w;
    motor_loop   = bg_loop_step(t, dt, motor_loop,                                        ...   
                                bg_inp{1}(t-1,:),                                         ... Striatal input
                                motor_cx_input(t,:),                                      ... Cortical input
                                da.activity);    
    ventral_cx_input(t,:)=bg_inp{2}(t-1,:) + motor_loop.crx2.activity(t-1,:) * motor2ventral_w;
    ventral_loop = bg_loop_step(t, dt, ventral_loop,                                      ... 
                                bg_inp{1}(t-1,:),                                         ... Striatal input
                                ventral_cx_input(t,:),                                    ... Cortical input
                                da.activity);    
    da           = leaky_step(t, dt,  da, inp_da(t-1), 0);
        

    % DA INPUT CONTROL
    if t>t_interv && sum(motor_loop.crx2.activity(t-t_interv:t,1)>=0.7)>=(t_interv) && t>(marker1+1000/dt)
        count_act1=count_act1+1;        
        marker1=t;
        if condition==2 || condition>=4
            inp_da(t)   =da_bursts;     %baseline=0.42 ---- 3 to have DA bursts responses
            inp_da(t+1) =da_bursts;     %baseline=0.42 ---- 3 to have DA bursts responses        
        end
    elseif t>t_interv && sum(motor_loop.crx2.activity(t-t_interv:t,3)>=0.7)>=(t_interv)
        if condition ==3
            inp_da(t)   =da_tonic;   %baseline=0.42 ---- 0.8 to simulate risk preference
        end
    end
    
    %Learning MOTOR
    motor_loop.crx2str = motor_loop.crx2str + motor_loop.crx2str*...
                        ((motor_loop.strd1.activity(t,:))>.3)'*((motor_loop.crx2.activity(t,:))>.7)...
                         *deltaL*(da.activity(t)>0.8) - motor_loop.crx2str*...
                        ((motor_loop.strd1.activity(t,:))<.3)'*((motor_loop.crx2.activity(t,:))>.7)...
                        *2*deltaL*(da.activity(t)>0.8);
    motor_loop.crx2str = min(l_th, motor_loop.crx2str);
    motor_loop.crx2str = max(0, motor_loop.crx2str);
    if motor_loop.crx2str(2,1)>.5 || motor_loop.crx2str(3,1)>.5
        disp('possible error in motor connection')
    end
    motor_loop.store_crx2str(t,:)=reshape(motor_loop.crx2str,1,9);

    %Learning VENTRAL
    ventral_loop.crx2str = ventral_loop.crx2str + ventral_loop.crx2str*...
                           ((ventral_loop.strd1.activity(t,:))>.3)'*((ventral_loop.crx2.activity(t,:))>.7)...
                           *deltaL*(da.activity(t)>0.8) - ventral_loop.crx2str*...
                           ((ventral_loop.strd1.activity(t,:))<.3)'*((ventral_loop.crx2.activity(t,:))>.7)...
                           *2*deltaL*(da.activity(t)>0.8);
    ventral_loop.crx2str = min(l_th, ventral_loop.crx2str);
    ventral_loop.crx2str = max(0, ventral_loop.crx2str);
    if ventral_loop.crx2str(2,1)>.5 || ventral_loop.crx2str(3,1)>.5
        disp('possible error in ventral connection')       
    end
    ventral_loop.store_crx2str(t,:)=reshape(ventral_loop.crx2str,1,9);    
    
    %counter Time
    if t/(600*1000/dt)==floor(t/(600*1000/dt))
        min_c=min_c+10;
        min10_count=num2str(min_c);
        min10_count=sprintf('Time counter (minutes): %s', min10_count);
        disp(min10_count)
        %disp('Time counter (minutes):')
        %disp(min_c)
    end
    %counter Action 2 and 3
    if t>t_interv && sum(motor_loop.crx2.activity(t-t_interv:t,2)>=0.7)>=(t_interv) && t>(marker2+1000/dt)
        count_act2=count_act2+1;        
        marker2=t;
    elseif t>t_interv && sum(motor_loop.crx2.activity(t-t_interv:t,3)>=0.7)>=(t_interv) && t>(marker3+1000/dt)
        count_act3=count_act3+1;
        marker3=t;        
    end
end

toc
%saving results over 60 minuts

if SECS==60*60
    str_cond=num2str(seed_n);
    if condition==1
        fname = sprintf('./store_seeds/control_seed%s_60min', str_cond);        
        %save('control_seed2_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');    
    elseif condition==2
        fname = sprintf('./store_seeds/habit_seed%s_60min', str_cond);
        %save('habit_seed1_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');        
    elseif condition==3
        fname = sprintf('./store_seeds/risk_seed%s_60min', str_cond);
        %save('risk_seed1_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');        
    elseif condition==4
        fname = sprintf('./store_seeds/treatment1_seed%s_60min', str_cond);
        %save('treatment1_seed1_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');        
    elseif condition==5
        fname = sprintf('./store_seeds/treatment2_seed%s_60min', str_cond);
        %save('treatment2_seed1_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');  
    elseif condition==6
        fname = sprintf('./store_seeds/relapse_timeT1_seed%s_60min', str_cond);        
        %save('relapse_timeT1_seed1_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact', 'time_recordT1');  
    elseif condition==7
        fname = sprintf('./store_seeds/relapse_timeT2_seed%s_60min', str_cond);        
        %save('relapse_timeT2_seed1_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact', 'time_recordT2');  
    elseif condition==8
        fname = sprintf('./store_seeds/formed_habit_seed%s_60min', str_cond);        
        %save('formed_habit_seed1_60min', 'motor_loop', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');          
    end
    if condition==1
        save(fname, 'motor_loop', 'ventral_loop', 'bg_inp', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');
    elseif condition>=2 && condition<=5 
        save(fname, 'motor_loop', 'ventral_loop', 'bg_inp', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact', 'time_recordT');
    elseif condition==6
        save(fname, 'motor_loop', 'ventral_loop', 'bg_inp', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact', 'time_recordT1');
    elseif condition==7
        save(fname, 'motor_loop', 'ventral_loop', 'bg_inp', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact', 'time_recordT2');
    elseif condition==8
        save(fname, 'motor_loop', 'ventral_loop', 'bg_inp', 'da', 'count_act1', 'count_act2', 'count_act3', 'targetact');
    end
end
condition_count=num2str(condition);
condition_count=sprintf('Condition count: %s', condition_count);
seed_count=num2str(seed_n);
seed_count=sprintf('Seed count: %s', seed_count);
disp(condition_count)
disp(seed_count)
end
end
range1=0;
range2=T;
%range1=7300;
%range2=7950;
%range1=16550;
%range2=17050;
%plot_da
%plotting_fun(T, SECS, motor_loop, bg_inp{1}, motor_cx_input, range1, range2)
%plotting_fun(T, SECS, ventral_loop, bg_inp{1}, ventral_cx_input, range1, range2)
%plot_actions

