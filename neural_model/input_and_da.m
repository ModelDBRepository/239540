inp_str = zeros(T,dim1);
inp_cx  = zeros(T,dim1);
targetact= zeros(1,dim1);

%inp(1,:)=[1 1 1];
marker=1;
for t=2:T

    if t==2 || floor(t/200)==t/200
        values=[.4 .3 .2];
        order_i=randperm(3);
        inp_str(t,:)=values(order_i)*0;
        inp_cx(t,:) =values(order_i);
        marker=t;
        if max(values) == inp_cx(t,1)
            targetact(1)=targetact(1)+1;
        elseif max(values) == inp_cx(t,2)
            targetact(2)=targetact(2)+1;            
        elseif max(values) == inp_cx(t,3)
            targetact(3)=targetact(3)+1;            
        end
    else
        inp_str(t,:)= inp_str(marker,:)+(rand(1,3)/5)*0;
        inp_cx(t,:) = inp_cx(marker,:) +(rand(1,3)/5);
    end
    
%     if t<T/2
%         inp_da(t)=da_baseline;   %0.42//1.1
%     else
%         inp_da(t)=da_baseline;   %0.42//1.1
%     end
    
end

bg_inp{1}=inp_str;
bg_inp{2}=inp_cx;

%     %random walk
%     if floor(t/200)==t/200
%         values=[.5 .4 .3];
%         order_i=randperm(3);
%         %inp_str(t,:)=(rand(1,3)/3)+0.3;
%         inp_cx(t,:)=values(order_i);
%     else
%         inp_str(t,:)=min(.3, max(0, inp_str(t-1,:)+(rand(1,3)/5)-0.1));
%         inp_cx(t,:) =min(.5, max(0, inp_cx (t-1,:)+(rand(1,3)/5)-0.1));
%     end