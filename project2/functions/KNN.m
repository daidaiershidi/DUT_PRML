function [test_label] = KNN(train, train_label, test, k)
% ���룺
% train = [N X d] ��ѵ�����ݣ�N��������ÿ��һ��dά������
% train_label = [N X 1] ��N���������ݵ����
% test = [N X d] ���������ݣ�N��������ÿ��һ��dά������
% k
% ���:
% label = [N X 1] ��N���������ݵķ���

[train_num, train_dim] = size(train);
[test_num, test_dim] = size(test);


test_label = [];
for test_index = 1:test_num
    test_sample = test(test_index, :);
    % ����ŷ�Ͼ���
    distances = [];
    for i = 1:train_num
        s = (train(i, :) - test_sample).^2;
        distance = sqrt( sum( s(:) ) );
        distances = [distances, distance];
    end
    % ����
    [sorted_distances, indexs] = sort(distances);
    % % ȡǰk����
    labels = [];
    for i = 1:k
        labels = [labels, train_label(indexs(i), :)];
    end
    % % �ж����
    unique_labels = unique(labels);
    count = histc(labels, unique_labels);
    [sorted_counts, indexs] = sort(count, 'descend');
    test_label = [test_label; unique_labels(indexs(1))];
end


end

