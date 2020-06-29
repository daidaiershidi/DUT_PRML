function [p] = parzen_windows_norm(xk, each_data)
% 计算parzen窗，窗函数为正态分布
% 输入：
% 测试样本xk:（1X2）
% 同类数据集each_data:（NX2）（N为样本数）
% 输出：
% xk对于each_data类数据的概率

u = [0, 0];
sigma = [1, 0; 0, 1];
% 计算概率
delta = 0;
for j = 1:length(each_data)
    x = xk -  each_data(j, :);
    delta_ = (1/(2*pi*sqrt(det(sigma)))).*exp( -0.5.*( (x-u)*inv(sigma)*(x-u)' ) ); 
    delta = delta + delta_;
end
p = delta ./ length(each_data);

end

