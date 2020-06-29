function [train,train_label,test,test_label] = get_N_data_in_each_subject(data, label, N)
% ��165�����ݼ��У�ÿ��subjectȡN����Ϊѵ������ʣ�������Լ�
% ���룺
% data = [165 X d]��ÿ��һ��dά����,ÿ11������ͬsubject,��15��subject
% label = [165 X 1]��ÿ11��ͬsubject��[1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;...]
% N = ÿ11�����������ȡN��
% �����
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

