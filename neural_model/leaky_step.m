
function output = leaky_step(t, dt, structure, inp_vec, neuromodulator)

if rand(1)>0.8
    noise=(rand(1, length(structure.activity(t,:)))).*structure.noise;
else
    noise=zeros(1, length(structure.activity(t,:)));
end

%structure.baseline=structure.baseline + ((rand(1, length(structure.activity(t,:)))*2-1)/10) .*structure.noise;

%action potential
structure.potential(t,:) = structure.potential(t-1,:) + (dt./structure.decay).*(-structure.potential(t-1,:) + ...
                            noise + structure.baseline + (structure.epsilon+structure.lambda*neuromodulator)* ...
                            (inp_vec + (structure.activity(t-1,:)*structure.self_w)));

%transfer function
structure.activity(t,:) = max (0, tanh(structure.potential(t,:).*(structure.potential(t,:)>structure.th_out)));

output = structure;