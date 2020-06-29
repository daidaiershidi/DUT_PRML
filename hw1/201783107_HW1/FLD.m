function [W] = FLD(X, types, d_)
% % 输入[x1,x2]， 类别数， 从小到大取前d_维特征向量
% % 输出W

% % 均分X
[len, dim] = size(X);
each_num = len / types;
% % 求Sw
mi = [];
Sw = zeros(dim, dim);
for i = 1:types
   start_num = (i-1) * each_num + 1;
   X_ = X(start_num:start_num + each_num - 1, :);
   mi_ = mean(X_);
   Sw_ = (X_ - mi_)' * (X_ - mi_);
   Sw = Sw + Sw_;
   mi = [mi; mi_];
end
% % 求Sb
m = mean(mi);
Sb = (mi - m)' * (mi - m) .* each_num;
% % 取c-1维的特征向量
[E, Langda] = eig(inv(Sw) * Sb);
Langdas = [];
for i = 1:length(Langda)
   Langdas = [Langdas, Langda(i, i)] ;
end
W = [];
[sorted_Langdas, indexs] = sort(Langdas, 'descend');
% [sorted_Langdas, indexs] = sort(Langdas);
for i = 1:d_
    if sorted_Langdas(i) ~= 0
        W = [W, E(:, indexs(i))];
    end
end


end

