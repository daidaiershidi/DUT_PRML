function [data_label,k_points] = k_means(data,k,threshold)
% ʹ��k�������
% ���룺
% data = [N X d] ��N�����ݣ�ÿ��һ��dά����
% k = k����
% threshold = �ж��Ƿ���µ���ֵ
% �����
% data_label = [N X 1] ��N�����ݶ�Ӧ��N����ǩ
% k_points = k����ʼ��

% ��ȡ��ʼ��
[data_num, data_dim] = size(data);
random_num = unidrnd(data_num, 1, k);
k_points = [];
for i = 1:k
    k_points = [k_points; data(random_num(i), :)];
end
% ����
if_update = [1,1,1];
while(sum(if_update) ~= 0)
    train = k_points;
    train_label = [1:1:k]';
    test = data;
    % ����ڷ���
    test_label = KNN(train, train_label, test, 1);
    % �����µĳ�ʼ��
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

