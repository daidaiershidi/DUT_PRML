function [A,B] = HMM_train(observation_seqs,Pi,A,B,max_iter_num)
% ���룺
% observation_seqs������ȳ��Ĺ۲�����
% Pi
% A
% B
% max_iter_num������������
% �����
% ѵ�����A��B


[state_num, observation_num] = size(B);

% �жϹ۲����������־�����cell
if isnumeric(observation_seqs)
    [seq_num, seq_length] = size(observation_seqs);
    observation_seq_is_cell = false;
elseif iscell(observation_seqs)
    seq_num = numel(observation_seqs);
    observation_seq_is_cell = true;
end


for iter_num = 1:max_iter_num
    % �½�new_A��new_B����
    new_A = zeros(state_num, state_num);
    new_B = zeros(state_num, observation_num);
    
    % �õ��۲�����
    for ith_seq = 1:seq_num % ����ÿһ�й۲�����
        if observation_seq_is_cell % �����cell
            seq = observation_seqs{ith_seq}; % �õ�һ������
            seq_length = length(seq); % �õ����г���
        else
            seq = observation_seqs(ith_seq,:); % �õ�һ������
        end
        
        % BWѵ��
        [Alpha,Beta,scale] = HMM_decode(seq,Pi,A,B);
        Pi_and_Alpha = [Pi, Alpha];
        Pi_and_Beta = [Pi, Beta];
        % ʹ��log
        log_Pi_and_Alpha = log(Pi_and_Alpha);
        log_Pi_and_Beta = log(Pi_and_Beta);
        log_B = log(B);
        log_A = log(A);
        
        for si = 1:state_num
            for sj = 1:state_num
                for ok = 1:seq_length
                    new_A(si,sj) = new_A(si,sj) + exp( log_Pi_and_Alpha(si,ok) + log_A(si,sj) + log_B(sj,seq(ok)) + log_Pi_and_Beta(sj,ok+1))./scale(ok);
                end
            end
        end
        
        for si = 1:state_num
            for ok = 1:observation_num
                pos_of_ok = find(seq == ok) + 1;
                new_B(si,ok) = new_B(si,ok) + sum(exp(log_Pi_and_Alpha(si,pos_of_ok)+log_Pi_and_Beta(si,pos_of_ok)));
            end
        end
    end
    % ÿ�й�һ��
    total_observation = sum(new_B,2);
    total_state = sum(new_A,2);
    B = new_B./total_observation;
    A  = new_A./total_state;
    % �����Ϊ0���У�ÿ�еĺ�Ӧ��Ϊ1��
    if any(total_state == 0)
        zero_row = find(total_state == 0);
        A(zero_row,:) = 0;
        A(sub2ind(size(A),zero_row,zero_row)) = 1;
    end
    if any(total_observation == 0)
        zero_row = find(total_observation == 0);
        B(zero_row,:) = 0;
        B(sub2ind(size(B),zero_row,zero_row)) = 1;
    end
    % ����NaN
    A(isnan(A)) = 0;
    B(isnan(B)) = 0;
end




end

