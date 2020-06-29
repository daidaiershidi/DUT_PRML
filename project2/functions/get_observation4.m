function [observation_seq] = get_observation4(x,y)
% ͨ����һ�ʵĽǶȼ���۲�����
% ���룺
% x
% y
% t
% length_of_seq���۲����еĳ���
% num_of_observation���۲�״̬�ĸ���
% state_num����״̬�ĸ���
% �����
% �۲�����
% ��״̬����

observation_seq = [];

[len, ~] = size(x);
for i = 1:len-1
    ix = x(i, :);
    iy = y(i, :);
    jx = x(i+1, :);
    jy = y(i+1, :);
    
    if(abs(ix-jx) >= abs(iy-jy))
        if(ix < jx)
            observation_seq = [observation_seq, 1];
        else
            observation_seq = [observation_seq, 2];
        end
    else
        if(iy < jy)
            observation_seq = [observation_seq, 3];
        else
            observation_seq = [observation_seq, 4];
        end
    end
    
end


end

