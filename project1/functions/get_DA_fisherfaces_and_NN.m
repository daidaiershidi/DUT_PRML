function [predict] = get_DA_fisherfaces(train, train_label, test, k)
% fisherfaces的变种方法，效果并不好http://www.docin.com/p-1418109138.html

% 计算DA-fisherfaces并用NN分类
% 输入：
% train_image = [N_train X d],每行为一个d维样本
% train_image_label = [N_train X 1]
% test_image = [N_test X d],每行为一个d维样本
% k = FLD降维后保留的维数
% 输出：
% predict = [N_test X 1]每行为预测的类别


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 初始处理
train = double(train);
[train_num, train_dim] = size(train);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% DA_disherfaces第一次求W_fld
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
[pcaX, W_pca] = fastPCA(train, train_num - 15);
[len, dim] = size(pcaX);
ni = len / 15;
% % 求Sw
mi = [];
Sw = zeros(dim, dim);
for i = 1:15
   start_num = (i-1) * ni + 1;
   X_ = pcaX(start_num:start_num + ni - 1, :);
   mi_ = mean(X_);
   Sw_ = (X_ - mi_)' * (X_ - mi_);
%    size(Sw)
%    size(Sw_)
   Sw = Sw + Sw_;
   mi = [mi; mi_];
end
% % 求Sb
m = mean(mi);
Sb = (mi - m)' * (mi - m) .* ni;
[E, Langda] = eig(pinv(Sw) * Sb);
Langdas = [];
for i = 1:length(Langda)
   Langdas = [Langdas, Langda(i, i)] ;
end
W_fld = [];
[sorted_Langdas, indexs] = sort(Langdas, 'descend');
% [sorted_Langdas, indexs] = sort(Langdas);
for i = 1:k
    if sorted_Langdas(i) ~= 0
        W_fld = [W_fld, E(:, indexs(i))];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


% DA_fisherface第一次分类
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mean_face = mean(train);
% 计算Z和W
Z = double(train) - mean_face;
W = (Z * W_pca * W_fld)';
% 计算p和W_new
p = double(test) - mean_face;
W_new = (p * W_pca * W_fld)';
% NN分类
distance = [];
[r, len] = size(W_new);
for i = 1:len
    W_new_ = W_new(:, i);
    distance = [distance; sum((W - W_new_).^2)];
end
[score, index] = min(distance, [], 2);
predict = [];
for i = 1:length(index)
    j =  ceil(index(i, :));
    predict = [predict; train_label(j)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 进行DA修正
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DA_X_ki = [];
nj = 11 - ni;
[mi_len, mi_dim] = size(mi);
for i = 1:length(mi_len)
    mi(i, :) = mi(i, :) .* (ni / (ni + nj));
end
for i = 1:length(predict)
    index = predict(i, :);
    mi(index, :) = mi(index, :) + (double(test(i, :)) * double(W_pca)) ./ (ni + nj);
end
for i = 1:length(mi_len)
    m = m + (1/15 .* mi(i, :));
end
m = 1/2 .* m;
% size(mi)
% size(m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 计算新的W_fld
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 求Sw
Sw = zeros(dim, dim);
for i = 1:15
   start_num = (i-1) * ni + 1;
   X_ = pcaX(start_num:start_num + ni - 1, :);
   mi_ = mi(i, :);
   Sw_ = (X_ - mi_)' * (X_ - mi_);
   Sw = Sw + Sw_;
end
% % 求Sb
Sb = (mi - m)' * (mi - m) .* ni;
% % 取c-1维的特征向量
% 如果警告: 矩阵接近奇异值，或者缩放错误。结果可能不准确。RCOND =  1.318679e-22。 
% 1.使用广义求逆pinv
% 2.使用PCA降维
[E, Langda] = eig(pinv(Sw) * Sb);
Langdas = [];
for i = 1:length(Langda)
   Langdas = [Langdas, Langda(i, i)] ;
end
W_fld = [];
[sorted_Langdas, indexs] = sort(Langdas, 'descend');
% [sorted_Langdas, indexs] = sort(Langdas);
for i = 1:k
    if sorted_Langdas(i) ~= 0
        W_fld = [W_fld, E(:, indexs(i))];
    end
end
% size(fldX)
% size(fisherfaces)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 用新的fisherfaces分类
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eigenfaces = pca(train);
% eigenfaces = eigenfaces(:, 1:k);
mean_face = mean(train);
% 计算Z和W
Z = double(train) - mean_face;
W = (Z * W_pca * W_fld)';
% 计算p和W_new
p = double(test) - mean_face;
W_new = (p * W_pca * W_fld)';
% NN分类
distance = [];
[r, len] = size(W_new);
for i = 1:len
    W_new_ = W_new(:, i);
    distance = [distance; sum((W - W_new_).^2)];
end
[score, index] = min(distance, [], 2);
predict = [];
for i = 1:length(index)
    j =  ceil(index(i, :));
    predict = [predict; train_label(j)];
end
% size(predict)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

