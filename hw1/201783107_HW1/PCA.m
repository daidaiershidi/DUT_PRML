function [E_] = PCA(X, d_)
% % 输入数据[x1, x2], 保留维数d_
% % 输出E_

% % 求均值和Z
Avg_X = mean(X);
Z = X - Avg_X;
% % 求散列矩阵S和特征值特征向量
S = Z' * Z;
[E, Langda] = eig(S);
Langdas = [];
for i = 1:length(Langda)
   Langdas = [Langdas, Langda(i, i)] ;
end
% % 取前d_个最大特征向量
E_ = [];
[sorted_Langdas, indexs] = sort(Langdas, 'descend');
for i = 1:d_
   E_ = [E_, E(:, indexs(i))];
end

end

