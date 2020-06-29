function [data_label,k_points] = k_means(data,k,threshold)
% 使用k聚类分类
% 输入：
% data = [N X d] ，N个数据，每行一个d维样本
% k = k个点
% threshold = 判断是否更新的阈值
% 输出：
% data_label = [N X 1] ，N个数据对应的N个标签
% k_points = k个初始点

% 获取初始点
[data_num, data_dim] = size(data);
random_num = unidrnd(data_num, 1, k);
k_points = [];
for i = 1:k
    k_points = [k_points; data(random_num(i), :)];
end
% 更新
if_update = [1,1,1];
while(sum(if_update) ~= 0)
    train = k_points;
    train_label = [1:1:k]';
    test = data;
    % 最近邻分类
    test_label = KNN(train, train_label, test, 1);
    % 计算新的初始点
    test_and_test_label = [test, test_label];
    for i = 1:k
        k_data = test_and_test_label(test_and_test_label(:, end) == i, :);
        k_data = k_data(:, 1:end-1);
        k_data_mean = mean(k_data);
        k_point = k_points(i, :);
        distance = sqrt(sum((k_data_mean - k_point) .^ 2));
        if(distance > threshold)
            k_points(i, :) = k_data_mean;
            if_update(i) = 1;
        else
            if_update(i) = 0;
        end
    end
end
data_label = test_label;


end

