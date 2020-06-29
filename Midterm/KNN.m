function [label] = KNN(train_datas, test_vector, k)
% % 输入：
% % 全部数据train_datas = [x1, x2, label]
% % 测试样本test_index = [x1, x2]
% % k
% % 输出类别

% % 计算欧氏距离
distances = [];
[h, w] = size(train_datas);
for i = 1:h
    train_vector = train_datas(i, 1:w - 1);
    s = (train_vector - test_vector).^2;
    distance = sqrt( sum( s(:) ) );
    distances = [distances, distance];
end
% % 排序
[sorted_distances, indexs] = sort(distances);
% % 取前k个点
labels = [];
for i = 1:k
   labels = [labels, train_datas(indexs(i), w)];
end
% % 判断类别
unique_labels = unique(labels);
count = histc(labels, unique_labels);
[sorted_counts, indexs] = sort(count, 'descend');
label = unique_labels(indexs(1));

end

