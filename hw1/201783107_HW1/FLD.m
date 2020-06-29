function [W] = FLD(X, types, d_)
% % ����[x1,x2]�� ������� ��С����ȡǰd_ά��������
% % ���W

% % ����X
[len, dim] = size(X);
each_num = len / types;
% % ��Sw
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
% % ��Sb
m = mean(mi);
Sb = (mi - m)' * (mi - m) .* each_num;
% % ȡc-1ά����������
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

