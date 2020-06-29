function [A,B,Pi] = get_state(observation_seq,state_seq,num_of_observation,state_num)


[state_seq_sum,state_seq_dim] = size(state_seq);
[observation_seq_sum,observation_seq_dim] = size(observation_seq);

A = eye(state_num) * 0.9 + 0.1;
Pi = zeros(1, state_num);
for i = 1:state_seq_sum
    for j = 1:state_seq_dim-1
%         [state_seq(i, j), state_seq(i, j+1)]
        A(state_seq(i, j), state_seq(i, j+1)) = A(state_seq(i, j), state_seq(i, j+1)) + 1;
        if(j == 1)
            Pi(state_seq(i, j)) = Pi(state_seq(i, j)) + 1;
        end
    end
end
A = A ./ sum(A,2);
Pi = (Pi ./ sum(Pi))';

B = zeros(state_num,num_of_observation) + 0.01;
for i = 1:observation_seq_sum
    for j = 1:state_seq_dim
        B(state_seq(i,j), observation_seq(i,j)) = B(state_seq(i,j), observation_seq(i,j)) + 1;
    end
end
B = B ./ sum(B,2);


end

