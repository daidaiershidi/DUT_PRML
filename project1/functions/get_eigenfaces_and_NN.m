function [predict] = eigenfaces_and_NN(train, train_label, test, k)
% ����eigenfaces����NN����
% ���룺
% train_image = [N_train X d],ÿ��Ϊһ��dά����
% train_image_label = [N_train X 1]
% test_image = [N_test X d],ÿ��Ϊһ��dά����
% k = PCA��ά������ά��
% �����
% predict = [N_test X 1]ÿ��ΪԤ������

train = double(train);
% ����eigenfaces��mean_face
[pcaX, eigenfaces] = fastPCA(train, k);
% eigenfaces = pca(train);
% eigenfaces = eigenfaces(:, 1:k);
mean_face = mean(train);
% ����Z��W
Z = double(train) - mean_face;
W = eigenfaces' * Z';
% ����p��W_new
p = double(test) - mean_face;
W_new = eigenfaces'* p';
% NN����
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

end

