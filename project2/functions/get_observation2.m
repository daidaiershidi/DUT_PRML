function [observation_seq,state_seq] = get_observation2(x,y,t,length_of_seq,num_of_observation,state_num)
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


new_xy = interp1(t,[x,y],linspace(min(t),max(t),length_of_seq+1)','spline');

% 计算观察序列
observation_seq = round(mod(atan2(diff(new_xy(:,2)), diff(new_xy(:,1))),2*pi) / (2*pi/num_of_observation));
observation_seq(observation_seq == 0) = num_of_observation;
observation_seq = observation_seq';
% size_seq = size(observation_seq)

% 估计隐状态http://wenda.chinahadoop.cn/question/3282
new_x=new_xy(1:end-1, 1); 
new_y=new_xy(1:end-1, 2);
edges_len = floor(sqrt(double(state_num)));
x_edges = linspace(min(new_x)-0.01, max(new_x)+0.01, edges_len+1);
pos_X = discretize(new_x,x_edges);
y_edges = linspace(min(new_y)-0.01, max(new_y)+0.01, edges_len+1);
pos_Y = discretize(new_y,y_edges);
state_seq = pos_X + (pos_Y-1)*edges_len;
state_seq = state_seq';



end

