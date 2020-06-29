function [observation_seq] = get_observation4(x,y)
% 通过下一笔的角度计算观察序列
% 输入：
% x
% y
% t
% length_of_seq：观察序列的长度
% num_of_observation：观察状态的个数
% state_num：隐状态的个数
% 输出：
% 观察序列
% 隐状态序列

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

