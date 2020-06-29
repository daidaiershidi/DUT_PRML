function [train,train_label,test,test_label] = get_N_data_in_each_subject(data, label, N)
% 在165个数据集中，每个subject取N个作为训练集，剩余做测试集
% 输入：
% data = [165 X d]，每行一个d维样本,每11行样本同subject,共15个subject
% label = [165 X 1]，每11行同subject，[1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;...]
% N = 每11行样本里随机取N个
% 输出：
% train = [15N X d]
% train_label = [15N X 1]
% test = [165-15N X d]
% train_label = [165-15N X 1]

train = [];
train_label = [];
test = [];
test_label = [];
for i =1:15
    subject = data((i-1)*11+1:i*11, :);
    subject_label = label((i-1)*11+1:i*11, :);
    
    [train_, train_label_, test_, test_label_] = split_train_test(subject, subject_label, N);
    train = [train; train_];
    train_label = [train_label; train_label_];
    test = [test; test_];
    test_label = [test_label; test_label_];
end


end

