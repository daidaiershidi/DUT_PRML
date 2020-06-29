function [label] = KNN(train_datas, test_vector, k)
% % ���룺
% % ȫ������train_datas = [x1, x2, label]
% % ��������test_index = [x1, x2]
% % k
% % ������

% % ����ŷ�Ͼ���
distances = [];
[h, w] = size(train_datas);
for i = 1:h
    train_vector = train_datas(i, 1:w - 1);
    s = (train_vector - test_vector).^2;
    distance = sqrt( sum( s(:) ) );
    distances = [distances, distance];
end
% % ����
[sorted_distances, indexs] = sort(distances);
% % ȡǰk����
labels = [];
for i = 1:k
   labels = [labels, train_datas(indexs(i), w)];
end
% % �ж����
unique_labels = unique(labels);
count = histc(labels, unique_labels);
[sorted_counts, indexs] = sort(count, 'descend');
label = unique_labels(indexs(1));

end

