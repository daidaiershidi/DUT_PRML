function [p] = normal_distribution(xk, u, sigma)
% 计算2维正态分布概率密度
% 输入：
% xk:2维样本(1X2)
% u:均值
% sigma:协方差
% 输出：
% 正态概率密度

p = (1/(2*pi*sqrt(det(sigma))))*exp(-0.5.*( (xk-u)*inv(sigma)*(xk-u)' ));

end

