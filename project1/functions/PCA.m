function [pcaX, E_, sorted_Langdas] = PCA(X, d_)
% % ��������[x1, x2], ����ά��d_
% % ���E_


X = double(X);
% % ���ֵ��Z
Avg_X = mean(X);
Z = X - Avg_X;
% % ��ɢ�о���S������ֵ��������
S = Z' * Z;
[E, Langda] = eig(S);
Langdas = [];
for i = 1:length(Langda)
   Langdas = [Langdas, Langda(i, i)] ;
end
% % ȡǰd_�������������
E_ = [];
[sorted_Langdas, indexs] = sort(Langdas, 'descend');
for i = 1:d_
    [i, size(indexs)];
    E_ = [E_, E(:, indexs(i))];
end

pcaX = Z * E;

end

