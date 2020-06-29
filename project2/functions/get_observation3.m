function [observation_seq] = get_observation3(kmeans_point,x,y,t,length_of_seq,num_of_observation,state_num)
% 通过kmeans计算观察序列
% 输入：
% kmeans_point：kmeans初值点
% x
% y
% t
% length_of_seq：观察序列的长度
% num_of_observation：观察状态的个数
% state_num：隐状态的个数
% 输出：
% 观察序列
% 隐状态序列


new_xy = interp1(t,[x,y],linspace(min(t),max(t),length_of_seq)','spline');
observation_seq = [];
for i = 1:length(new_xy)
    distances = sum( (kmeans_point - new_xy(i, :)).^2, 2 );
%     distances_size = size(distances)
    [max_value, max_index] = max(distances);
    observation_seq = [observation_seq, max_index];
end




end

