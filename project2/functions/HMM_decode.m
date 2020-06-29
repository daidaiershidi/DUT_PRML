function [Alpha, Beta, sum_of_each_Alpha_column] = HMM_decode(seq,Pi,A,B)
% ����ǰ�����㷨���aplha��beta
% ����״̬Si������num_of_state,�ɱ��۲��״̬Vm����num_of_Vm
% ����һ���۲�����seq = [V1, V3, V2, V1]�����еĳ���Ϊlength_of_seq = 4
%
% size(Pi) = (1, num_of_state)
% size(A) = (num_of_state, num_of_state)
% size(B) = (num_of_state, num_of_Vm)
% size(alpha) = (num_of_state, length_of_seq)
% size(beta) = (num_of_state, length_of_seq)



[num_of_state, num_of_Vm] = size(B);
length_of_seq = length(seq);


% ������ʦPPT�ϵĹ�ʽ����ǰ��Alpha
Alpha = zeros(num_of_state, length_of_seq);
sum_of_each_Alpha_column = zeros(1, length_of_seq);
for ok = 1:length_of_seq
    for si = 1:num_of_state
        if(ok == 1)
            Alpha(si, ok) = sum(Pi .* A(:, si)) * B(si, seq(ok)); % ��matlabһ��
        else
            Alpha(si, ok) = sum(Alpha(:, ok-1) .* A(:, si)) * B(si, seq(ok));
        end
    end
    sum_of_each_Alpha_column(ok) = sum(Alpha(:,ok));
    Alpha(:,ok) = Alpha(:,ok) ./ sum_of_each_Alpha_column(ok);
end

% ������ʦPPT�ϵĹ�ʽ�������Beta
Beta = ones(num_of_state, length_of_seq);
for ok = length_of_seq-1:-1:1
    for si = 1:num_of_state
            Beta(si,ok) = (1/sum_of_each_Alpha_column(ok + 1)) * sum( A(si,:)'.* Beta(:,ok+1) .* B(:,seq(ok+1))); 
    end
end


end

