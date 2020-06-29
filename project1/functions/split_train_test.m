function [train, train_label, test, test_label] = split_train_test(data, label, train_num)
% 在data中随机取train_num作为训练集，剩余做测试集
% 输入：
% data=[N X d]，每行一个d维样本
% label=[N X 1]
% train_num 随机取train_num个样本当做训练集
% 输出：
% train = [train_num X d]
% train_label = [train_num X 1]
% test = [N-train_num X d]
% test_label = [N-train_num X 1]

data_size = size(data);
N = data_size(1);
random_index = randperm(N);

train = [];
train_label = [];
test = [];
test_label = [];
for i = 1:train_num
    train = [train; data(random_index(i), :)];
    train_label = [train_label; label(random_index(i), :)];
end
for i = train_num+1:N
    test = [test; data(random_index(i), :)];
    test_label = [test_label; label(random_index(i), :)];
end
    
end

