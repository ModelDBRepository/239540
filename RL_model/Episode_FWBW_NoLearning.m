function [ total_reward,i,Q,Model,last_actions,last_states,last_reward,last_Q,lastMaxK,lastMaxVar,lastDreward,lastMA_noise_n ] = Episode_FWBW_NoLearning( maxsteps, alpha, gamma,epsilon,MFParameters,grafic,Environment,start,p_steps )
% Episode do one episode of the mountain car with sarsa learning
% maxstepts: the maximum number of steps per episode
% Q: the current QTable
% alpha: the current learning rate
% gamma: the current discount factor
% epsilon: probablity of a random action
% statelist: the list of states
% actionlist: the list of actions

% Maze
% based on the code of:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
%
%
MBParameters=struct('alpha_MB',alpha,...
    'StoppingPathThreshMB',1e-6,...
    'stoppingThreshMB',20,...
    'StoppingPathLengthMB',6,...
    'MaxItrMB',10,...
    'StopSimMB',10,...
    'SelectActionSimMB','DYNA',...
    'knownTransitions',1,...
    'stopOnUncertaintyVal',1,...
    'gamma_MB',MFParameters.gamma_MF,...
    'lambda_MB',MFParameters.lambda_MF,...,
    'sigma_square_noise_external',0.000001,...
    'noiseVal',0.000001,...
    'noiceVar',0.000001);

    MBReplayParameters = struct(...
        'P_starting_point_high_R',0.1,...
        'P_starting_point_Low_R',0.1,...
        'P_starting_point_recent_change',0.1,...
        'restart_sweep_Prob',0.3,... %'frequency',2,...
        'sweeps',4,...
        'sweepsDepth',4,...
        'stepsTotal',8,...
        'P_update_After_Reward',2);
    
MBParameters=setstructfields(MBParameters,MFParameters);

MBReplayParameters=setstructfields(MBReplayParameters,MBParameters);

QTablePerm_t.mean=zeros(Environment.Num_States,Environment.Num_Actions);
QTablePerm_t.time=zeros(Environment.Num_States,Environment.Num_Actions);
QTablePerm_t.var=1.5*eye(Environment.Num_States*Environment.Num_Actions);
QTablePerm=QTablePerm_t;

last_actions=zeros(1,maxsteps);

last_states=zeros(1,maxsteps);

last_reward=zeros(1,maxsteps);
lastMaxK=zeros(1,maxsteps);
lastMaxVar=lastMaxK;
lastDreward=lastMaxK;
lastMA_noise_n=lastMaxK;


last_Q=zeros(maxsteps,Environment.Num_States,Environment.Num_Actions);








Model =CreateModel(Environment,MBParameters,4);

currentState           = start;

total_reward = 0;


% selects an action using the epsilon greedy selection strategy
%a   = e_greedy_selection(Q,s,epsilon);

stateActionVisitCounts=zeros(Environment.Num_States,Environment.Num_Actions);

for i=1:maxsteps
    
    %run internal simulations
    [Qtable_Integrated,~]=runInternalSimulation(QTablePerm,currentState,Model,Environment,MBParameters,1);
    %Qtable_Integrated=QTablePerm;
    %select action a
    action=actionSelection(currentState,Model,MBParameters, Qtable_Integrated,Environment,stateActionVisitCounts);
    
    %do the selected action and get the next car state
    [reward, new_state]  = DoAction( action , currentState, Environment );
    
    QTablePerm=Qtable_Integrated;
    
    %Model=updateModel(reward, new_state,action , currentState,Model,alpha_model);
    
    
    [QTablePerm,maxK,maxVar,dreward,MA_noise_n]=updateQTablePerm(Qtable_Integrated,reward, new_state,action , currentState, MBParameters,0);
    
    
    
    

    
    QTablePerm=internalReplay(QTablePerm,Model,Environment,MBReplayParameters);
    
    
    
    
    last_actions(i)=action;
    
    last_states(i)=currentState;
    
    last_reward(i)=reward;
    %lastMaxK(i)=maxK;
    %lastMaxVar(i)=maxVar;
    %lastDreward(i)=max(abs(dreward));
    %lastMA_noise_n(i)=MA_noise_n;
    
    
    last_Q(i,:,:)=QTablePerm.mean;
    currentState=new_state;
    
    
    
    Q=QTablePerm.mean;
end


