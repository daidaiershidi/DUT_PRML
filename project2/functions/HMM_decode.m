function [Alpha, Beta, sum_of_each_Alpha_column] = HMM_decode(seq,Pi,A,B)
% 计算前后向算法里的aplha和beta
% 设隐状态Si的数量num_of_state,可被观测的状态Vm数量num_of_Vm
% 给定一个观测序列seq = [V1, V3, V2, V1]，序列的长度为length_of_seq = 4
%
% size(Pi) = (1, num_of_state)
% size(A) = (num_of_state, num_of_state)
% size(B) = (num_of_state, num_of_Vm)
% size(alpha) = (num_of_state, length_of_seq)
% size(beta) = (num_of_state, length_of_seq)



[num_of_state, num_of_Vm] = size(B);
length_of_seq = length(seq);


% 按照老师PPT上的公式计算前向Alpha
Alpha = zeros(num_of_state, length_of_seq);
sum_of_each_Alpha_column = zeros(1, length_of_seq);
for ok = 1:length_of_seq
    for si = 1:num_of_state
        if(ok == 1)
            Alpha(si, ok) = sum(Pi .* A(:, si)) * B(si, seq(ok)); % 与matlab一致
        else
            Alpha(si, ok) = sum(Alpha(:, ok-1) .* A(:, si)) * B(si, seq(ok));
        end
    end
    sum_of_each_Alpha_column(ok) = sum(Alpha(:,ok));
    Alpha(:,ok) = Alpha(:,ok) ./ sum_of_each_Alpha_column(ok);
end

% 按照老师PPT上的公式计算后向Beta
Beta = ones(num_of_state, length_of_seq);
for ok = length_of_seq-1:-1:1
    for si = 1:num_of_state
            Beta(si,ok) = (1/sum_of_each_Alpha_column(ok + 1)) * sum( A(si,:)'.* Beta(:,ok+1) .* B(:,seq(ok+1))); 
    end
end


end

