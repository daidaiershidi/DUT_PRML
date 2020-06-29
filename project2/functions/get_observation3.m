function [observation_seq] = get_observation3(kmeans_point,x,y,t,length_of_seq,num_of_observation,state_num)
% ͨ��kmeans����۲�����
% ���룺
% kmeans_point��kmeans��ֵ��
% x
% y
% t
% length_of_seq���۲����еĳ���
% num_of_observation���۲�״̬�ĸ���
% state_num����״̬�ĸ���
% �����
% �۲�����
% ��״̬����


new_xy = interp1(t,[x,y],linspace(min(t),max(t),length_of_seq)','spline');
observation_seq = [];
for i = 1:length(new_xy)
    distances = sum( (kmeans_point - new_xy(i, :)).^2, 2 );
%     distances_size = size(distances)
    [max_value, max_index] = max(distances);
    observation_seq = [observation_seq, max_index];
end




end

