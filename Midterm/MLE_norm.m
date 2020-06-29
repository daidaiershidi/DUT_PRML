function [u, sigma] = MLE_norm(each_data)
% 同一类数据集的2维正态分布的最大似然估计
% 输入：
% each_data（同一类数据集） shape:(NX2)(N是样本数量，2是维度)
% 输出：
% 估计出的参数


% 计算矩阵u和sigma
u = mean(each_data);
sigma = zeros(length(u), length(u));
for i = 1:length(each_data)
    xk = each_data(i, :);
    sigma = sigma + ((xk-u)' * (xk-u));
end
sigma = sigma ./ length(each_data);


end

