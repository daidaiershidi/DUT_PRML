function [test_label] = KNN(train, train_label, test, k)
% 输入：
% train = [N X d] ，训练数据，N个样本，每行一个d维的样本
% train_label = [N X 1] ，N个测试数据的类别
% test = [N X d] ，测试数据，N个样本，每行一个d维的样本
% k
% 输出:
% label = [N X 1] ，N个测试数据的分类

[train_num, train_dim] = size(train);
[test_num, test_dim] = size(test);


test_label = [];
for test_index = 1:test_num
    test_sample = test(test_index, :);
    % 计算欧氏距离
    distances = [];
    for i = 1:train_num
        s = (train(i, :) - test_sample).^2;
        distance = sqrt( sum( s(:) ) );
        distances = [distances, distance];
    end
    % 排序
    [sorted_distances, indexs] = sort(distances);
    % % 取前k个点
    labels = [];
    for i = 1:k
        labels = [labels, train_label(indexs(i), :)];
    end
    % % 判断类别
    unique_labels = unique(labels);
    count = histc(labels, unique_labels);
    [sorted_counts, indexs] = sort(count, 'descend');
    test_label = [test_label; unique_labels(indexs(1))];
end


end

