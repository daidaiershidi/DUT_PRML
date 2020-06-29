%%
addpath .\functions
%%
% ��ȡxmlȫ���ļ�
file_name = ['a.xml'; 'e.xml'; 'i.xml'; 'o.xml'; 'u.xml'];
file_path = '.\project2-data\project2-data\';
data = [];
for i = 1:5
    data{i} = read_xml([file_path, file_name(i, :)]);
end
clear i



%%
% kmeans
X = [];
for i = 1:5
    for j = 1:40
        X = [X; data{i}{j}(:,1:2)];
    end
end
[X_label,kmeans_point] = k_means(X, 8, 0.01);

        
%%
% kmeans��ͼ
color = {'r','g','b','y','m','c','w','k'};
for i = 1:length(X_label)
    i
    scatter(X(i, 1), X(i, 2), color{X_label(i)});
    hold on
end


%%
% �õ�ѵ�����ݺͲ�������
train = [];
test = [];
for i = 1:5
    for j = 1:40
        if(mod(j, 2) == 0)
            test{(i-1) * 20 + j/2} = data{i}{j}(:, 1:3);
        else
            train{(i-1) * 20 + (j+1)/2} = data{i}{j}(:, 1:3);
        end
    end
end


%%
observation_seq_length = 10; % �۲����г���
observation_state_num = 8; % �۲�״̬�ܸ���
state_num = 1; % ��״̬�ܸ���

x_or_y = 0; % ��ͼʱ�ȷֵ������ᣬ0��ʾx�ᣬ1��ʾy��

% �õ�ѵ�����ݵĹ۲�����
train_observation_seq = [];
train_state_seq = [];
for i = 1:length(train)
    ith_train_sample = train{i};
    x = ith_train_sample(:, 1);
    y = ith_train_sample(:, 2);
    t = ith_train_sample(:, 3);
    
    % ͨ����ͼ��ù۲�����
%     xynew = interp1(t, [x,y], linspace(min(t),max(t),1000)');
%     ith_train_sample_observation_seq = get_observation1(xynew, observation_seq_length, observation_state_num-1, x_or_y);
    % ͨ����һ����ķ����ù۲�����
    [ith_train_sample_observation_seq,ith_train_sample_state_seq] = get_observation2(x,y,t,observation_seq_length, observation_state_num,state_num);
    % ͨ��kmeans��ù۲�����
%     [ith_train_sample_observation_seq] = get_observation3(kmeans_point,x,y,t,observation_seq_length,observation_state_num,state_num);
    
    train_state_seq = [train_state_seq; ith_train_sample_state_seq];
    train_observation_seq = [train_observation_seq; ith_train_sample_observation_seq];
end

% �õ��������ݵĹ۲�����
test_observation_seq = [];
for i = 1:length(test)
    ith_test_sample = test{i};
    x = ith_test_sample(:, 1);
    y = ith_test_sample(:, 2);
    t = ith_test_sample(:, 3);
    
    % ͨ����ͼ��ù۲�����
%     xynew = interp1(t, [x,y], linspace(min(t),max(t),1000)');
%     ith_test_sample_observation_seq = get_observation1(xynew, observation_seq_length, observation_state_num-1, x_or_y);
    % ͨ����һ����ķ����ù۲�����
    [ith_test_sample_observation_seq,~] = get_observation2(x,y,t,observation_seq_length, observation_state_num,state_num);
    % ͨ��kmeans��ù۲�����
%     [ith_test_sample_observation_seq] = get_observation3(kmeans_point,x,y,t,observation_seq_length,observation_state_num,state_num);
    
    test_observation_seq = [test_observation_seq; ith_test_sample_observation_seq];
end


%%
% % ����õ�A��B��Pi
% train_A = [];
% train_B = [];
% train_Pi = [];
% for i =1:5
%     A = rand([state_num, state_num]);
%     A = A ./ sum(A, 2);
%     
% %     B = rand([state_num, observation_state_num]);
% %     B = B ./ sum(B, 2);
% %     B = ones([state_num, observation_state_num]);
% %     B = B ./ (state_num*observation_state_num);
%     B = zeros([state_num, observation_state_num]);
%     B(:, 1) = 1;
%     
%     Pi = rand([state_num, 1]);
%     Pi = Pi ./ sum(Pi);
%     train_A{i} = A;
%     train_B{i} = B;
%     train_Pi{i} = Pi;   
% end

% ͨ������õ�A��B��Pi
train_A = [];
train_B = [];
train_Pi = [];
for i =1:5
    start_num = (i-1) * 20 + 1;
    end_num = i * 20;
    observation_seq = train_observation_seq(start_num:end_num, :);
    state_seq = train_state_seq(start_num:end_num, :);
    [A,B,Pi] = get_state(observation_seq,state_seq,observation_state_num,state_num);
    train_A{i} = A;
    train_B{i} = B;
    train_Pi{i} = Pi;
end

%%
% ѵ��
for i =1:5
    start_num = (i-1) * 20 + 1;
    end_num = i * 20;
    seq = train_observation_seq(start_num:end_num, :);
    [new_A, new_B] = HMM_train(seq,train_Pi{i},train_A{i},train_B{i},500);
    train_A{i} = new_A;
    train_B{i} = new_B;
end


%%
% ����
likelyhood = [];
for i = 1:5
    start_num = (i-1) * 20 + 1;
    end_num = i * 20;
    test_seq = test_observation_seq(start_num:end_num, :);
    for j = 1:20
        seq = test_seq(j, :);
        seq_likelyhood = [];
        for k = 1:5
            [~, ~, scale] = HMM_decode(seq,train_Pi{k},train_A{k},train_B{k});
            logP = sum(log(scale));
            seq_likelyhood = [seq_likelyhood, logP];
        end
        likelyhood = [likelyhood; seq_likelyhood];
    end
end

C = zeros(5, 5);
test_label = [];
for i = 1:length(likelyhood)
        [max_logP, max_index] = max(likelyhood(i, :));
        test_label = [test_label; [max_index, max_logP]];
        C(ceil(i/20), max_index) = C(ceil(i/20), max_index) + 1;
end
C
