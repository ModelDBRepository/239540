%environmentParameters=struct(...
%   n_healthy_goals,V_n_healthy_goals,...
%   rew_Goals,Vrew_Goals,...
%   p_GetRewardGoals,Vp_GetRewardGoals
%   n_drug_goals,V_n_drug_goals,...
%   rew_DG,V_rew_DG,...
%   pun_DG,V_pun_DG,...
%   escaLation_factor_DG,V_escaLation_factor_DG,...
%   n_base_states,V_n_base_states,...
%   deterministic,V_deterministic);

function [Environment]  = CreateEnvironment(environmentParameters)
%%define state space
Num_States=environmentParameters.n_healthy_goals+environmentParameters.n_drug_goals+environmentParameters.n_base_states;
%%define action space
if (environmentParameters.n_drug_goals>0)
    Num_Actions=environmentParameters.n_healthy_goals+2;
    a_getDrugs=(environmentParameters.n_healthy_goals+2);
    actionName{a_getDrugs}='a-getDrugs';
else
    Num_Actions=environmentParameters.n_healthy_goals+1;
end;
a_stay=(environmentParameters.n_healthy_goals+1);
actionName{a_stay}='a-stay';


ps=cell(Num_States,Num_Actions);
reward=cell(Num_States,Num_Actions);
nextState=cell(Num_States,Num_Actions);
gr_idx=1;
%% define transition and reward probabilites
%%define goal state dynamics
for st = 1:(environmentParameters.n_healthy_goals)
    nodenames{st}=strcat('goal-', int2str(st));
    for action=1:Num_Actions
        if (action==st)
            actionName{st}=strcat('a-Goal-',num2str(st));
            r=environmentParameters.rew_Goals(st);
            reward{st,action}=[0 r*ones(1,environmentParameters.n_base_states)];
            ps{st,action}(:)=[(1-environmentParameters.p_GetRewardGoals),environmentParameters.p_GetRewardGoals*ones(1,environmentParameters.n_base_states)/environmentParameters.n_base_states];
            nextState{st,action}(:)=[st, 1+(1:environmentParameters.n_base_states)];
            
        else
            reward{st,action}=[0 ];
            ps{st,action}=[1];
            nextState{st,action}=[st];
        end
    end
end

for st = (environmentParameters.n_healthy_goals+1):(environmentParameters.n_healthy_goals+environmentParameters.n_base_states)
    nodenames{st}=['base-', int2str(st)];
    for action=1:Num_Actions
        display(['start: ' nodenames(st) ' act: ' actionName{action}])
        if(action<=environmentParameters.n_healthy_goals)
            display('a')
            reward{st,action}=[0 0];
            ps{st,action}=[(1-environmentParameters.p_GetRewardGoals),environmentParameters.p_GetRewardGoals];
            nextState{st, action}=[action, (environmentParameters.n_healthy_goals+randi(environmentParameters.n_base_states))];
        else if action==(a_stay)
                display('b')
                reward{st,action}=[0];
                ps{st,action}=[1];
                nextState{st, action}=[st];
                
            else if action==(a_getDrugs)%action_get_drugs
                    if (environmentParameters.autoGen==1)
                        display('c')
                        reward{st,action}=environmentParameters.rew_DG*...
                            [((ones(1,environmentParameters.n_drug_goals))./(((1/environmentParameters.escaLation_factor_DG)*ones(1,environmentParameters.n_drug_goals)).^(1:environmentParameters.n_drug_goals))),  0];
                        
                        ps{st,action}(1:environmentParameters.n_drug_goals)=((ones(1,environmentParameters.n_drug_goals))./(((1/environmentParameters.escaLation_factor_DG)*ones(1,environmentParameters.n_drug_goals)).^(1:environmentParameters.n_drug_goals)));
                        ps{st,action}(1+environmentParameters.n_drug_goals)=1-sum(ps{st,action}(1:environmentParameters.n_drug_goals));
                        display('check')
                        display(int2str(ps{st,action}(:)));
                    else
                        display('d')
                        reward{st,action}=[environmentParameters.rew_DGV,0];
                        ps{st,action}=[environmentParameters.pDGV, 1-sum(environmentParameters.pDGV)];
                    end
                    nextState{st, action}=[(environmentParameters.n_healthy_goals+environmentParameters.n_base_states+(1:environmentParameters.n_drug_goals)), (environmentParameters.n_healthy_goals+randi(environmentParameters.n_base_states))];
                end
            end
        end
    end
    
    for st= (environmentParameters.n_healthy_goals+environmentParameters.n_base_states)+(1:environmentParameters.n_drug_goals)
        nodenames{st}=['drug-', int2str(st)];
        stpos=(st-environmentParameters.n_healthy_goals-environmentParameters.n_base_states);
        r1=environmentParameters.pun_DG*environmentParameters.escaLation_factor_DG^(environmentParameters.n_drug_goals-stpos);
        p1=environmentParameters.pDG*environmentParameters.escaLation_factor_DG^(environmentParameters.n_drug_goals-stpos);
        for action=1:Num_Actions
            if(action<=environmentParameters.n_healthy_goals)
                reward{st,action}=[r1];
                ps{st,action}=[1];
                nextState{st, action}=[st];
            else if(action==a_stay)
                    reward{st,action}=[r1,r1];
                    ps{st,action}=[p1,1-p1];
                    nextState{st, action}=[st,(environmentParameters.n_healthy_goals+randi(environmentParameters.n_base_states))];
                else  if(action==a_getDrugs)
                        if (environmentParameters.autoGen==1)
                            onesvector=ones(1,environmentParameters.n_drug_goals-stpos+1);
                            
                            reward{st,action}=[environmentParameters.rew_DG*...
                                ((onesvector)./(((1/environmentParameters.escaLation_factor_DG)*onesvector).^(stpos-1+(1:environmentParameters.n_drug_goals-stpos+1)))),...
                                r1];
                            vint=onesvector./(((1/environmentParameters.escaLation_factor_DG)...
                                *onesvector).^(stpos-1+(1:environmentParameters.n_drug_goals-stpos+1)))
                            ps{st,action}(:)=[...
                                vint,...
                                (1-p1)];
                            p1
                            vmalo=[...
                                vint,...
                                (1-p1)]
                            size1=size([...
                                vint,...
                                (1-p1)])
                            onesvector
                            sizeonesvector=(onesvector);
                            sizevint=size(vint)
                            vint
                            vec=ps{st,action}(:)
                            sizeps=size(ps{st,action})
                            sizevec=size(vec)
                            sumpsaction=sum(ps{st,action}(:))
                            
                            
                            ps{st,action}(:)=ps{st,action}(:)/sumpsaction;
                        else
                            reward{st,action}=environmentParameters.rew_DGV;
                            ps{st,action}=environmentParameters.pDGV;
                        end
                        nextState{st, action}=[(environmentParameters.n_healthy_goals+environmentParameters.n_base_states)+(stpos:environmentParameters.n_drug_goals), st];
                    end
                end
            end
        end
    end
    
    %% back search model
    
    kx=ones(Num_States,1);
    for previousState=1:Num_States
        for action=1:Num_Actions
            for j=1:length(nextState{previousState, action})
                endState=nextState{previousState, action}(j);
                k=kx(endState);
                kx(endState)=k+1;
                PreviousStates{endState}(k)=previousState;
                InverseActions{endState}(k)=action;
                InverseReward{endState}(k)=reward{previousState,action}(j);
                InversePs{endState}(k)=ps{previousState,action}(j);
                %s(gr_idx)=previousState;
                %t(gr_idx)=endState;
                %w(gr_idx)=ps{previousState,action}(j);
                %nodeLab{gr_idx}=['a_' int2str(action) '_r_' int2str(reward{previousState,action}(j))];
                %gr_idx=gr_idx+1;
            end
            
        end
    end
    
    Environment.Num_States=Num_States;
    Environment.Num_Actions=Num_Actions;
    Environment.actionName=actionName;
    Environment.nodenames=nodenames;
    Environment.reward=reward;
    Environment.ps=ps;
    Environment.nextState=nextState;
    Environment.PreviousStates=PreviousStates;
    Environment.InverseActions=InverseActions;
    Environment.InverseReward=InverseReward;
    Environment.InversePs=InversePs;
    
    %G = graph(s,t,w)
    
end