function [predict] = get_fisherfaces_and_NN(train, train_label, test, k)
% 计算eigenfaces并用NN分类
% 输入：
% train_image = [N_train X d],每行为一个d维样本
% train_image_label = [N_train X 1]
% test_image = [N_test X d],每行为一个d维样本
% k = FLD降维后保留的维数
% 输出：
% predict = [N_test X 1]每行为预测的类别

train = double(train);
[train_sample_num, ~] = size(train);

% 计算fisherfaces和mean_face
[pcaX, W_pca] = fastPCA(train, train_sample_num - 15);
[~, W_fld] = FLD(pcaX, 15, k);

mean_face = mean(train);

% 计算Z和W
Z = double(train) - mean_face;
W = (Z * W_pca * W_fld)';
size(W)
% 计算p和W_new
p = double(test) - mean_face;
W_new = (p * W_pca * W_fld)';
size(W_new)
% NN分类
distance = [];
[~, len] = size(W_new);
for i = 1:len
    W_new_ = W_new(:, i);
    distance = [distance; sum((W - W_new_).^2)];
end
[~, index] = min(distance, [], 2);
predict = [];
for i = 1:length(index)
    j =  ceil(index(i, :));
    predict = [predict; train_label(j)];
end



end

