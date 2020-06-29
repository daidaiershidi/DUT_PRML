%%
addpath ./functions
observation_seq_length = 10; % 观察序列长度
observation_state_num = 4; % 观察状态总个数
state_num = 4; % 隐状态总个数

%%
% 读取视频
path = '.\KTH_data_set';
sub_path = dir(path);

all_video = [];
for i = 1:length(sub_path)
    % 如果不是文件夹，就跳过
    if( isequal( sub_path(i).name, '.' ) ||  isequal( sub_path(i).name, '..' ) || ~sub_path(i).isdir )   
        continue; 
    end
    % 得到第i类视频的全部视频名
    ith_type_videos = dir(fullfile(path, sub_path(i).name, '*.avi'));
    all_video{i - 2} = [];
    '共有视频数：'
    length(ith_type_videos)
    for j = 1:10%length(ith_type_videos)
        % 得到第i类视频的第j个视频名
        jth_video_path = [path, '\', sub_path(i).name, '\', ith_type_videos(j).name];
        jth_video = VideoReader(jth_video_path); % 读视频
        all_video{i - 2}{j} = jth_video;
    end
    '视频数：'
    size(all_video{i - 2})
end

%%
% 得到训练数据和测试数据
train = [];
test = [];
for i = 4:6
    ith_type_video_sum = length(all_video{i});
    train{i} = [];
    test{i} = [];
    
    for j = 1:ith_type_video_sum
        
        video = all_video{i}{j};
        if(mod(j, 2) == 0)
%             test{i}{j/2} = get_video_observation(video, observation_state_num);
            s = get_video_observation(video);
            [i, j, ith_type_video_sum, s]
        else
%             train{i}{(j+1)/2} = get_video_observation(video, observation_state_num);
            s = get_video_observation(video);
            [i, j, ith_type_video_sum, s]
        end
    end
    
end
%%
video = all_video{1}{1};
get_video_observation(video);


%%
for k = 1
    for i = 1:5
        xyt = train{k}{i};
        scatter(xyt(:, 1), xyt(:, 2));
        hold on

    end
end

%%

x_or_y = 0; % 画图时等分的坐标轴，0表示x轴，1表示y轴

% 得到训练数据的观察序列
train_observation_seq = [];
train_state_seq = [];
for i = 1:6
    ith_type_train_sum = length(train{i});
    train_observation_seq{i} = [];
    train_state_seq{i} = [];
    for j = 1:ith_type_train_sum
        [i, j, ith_type_train_sum]
        x = train{i}{j}(:, 1);
        y = train{i}{j}(:, 2);
        t = train{i}{j}(:, 3);
        
        [jth_train_sample_observation_seq,jth_train_sample_state_seq] = get_observation2(x,y,t,observation_seq_length, observation_state_num,state_num);
        
%         xynew = interp1(t, [x,y], linspace(min(t),max(t),1000)');
%         jth_train_sample_observation_seq = get_observation1([x,y,t], observation_seq_length, observation_state_num-1, x_or_y);
        
        
        train_state_seq{i} = [train_state_seq{i}; jth_train_sample_state_seq];
        train_observation_seq{i} = [train_observation_seq{i}; jth_train_sample_observation_seq];
    end
end

% 得到测试数据的观察序列
test_observation_seq = [];
for i = 1:6
    ith_type_test_sum = length(test{i});
    test_observation_seq{i} = [];
    for j = 1:ith_type_test_sum
        [i, j, ith_type_test_sum]
        x = test{i}{j}(:, 1);
        y = test{i}{j}(:, 2);
        t = test{i}{j}(:, 3);
        
        [jth_test_sample_observation_seq,~] = get_observation2(x,y,t,observation_seq_length, observation_state_num,state_num);
        
%         xynew = interp1(t, [x,y], linspace(min(t),max(t),1000)');
%         jth_test_sample_observation_seq = get_observation1([x,y,t], observation_seq_length, observation_state_num-1, x_or_y);
        
        test_observation_seq{i} = [test_observation_seq{i}; jth_test_sample_observation_seq];
    end
end

%%
k = 1;
for i = 1:length(train{k})
    xyt = train{k}{i};
    [observation_seq] = get_observation4(xyt(:, 1),xyt(:, 2))
end



%%
% % 随机得到A，B，Pi
% train_A = [];
% train_B = [];
% train_Pi = [];
% for i =1:6
%     A = rand([state_num, state_num]);
%     A = A ./ sum(A, 2);
%     
%     B = rand([state_num, observation_state_num]);
%     B = B ./ sum(B, 2);
% %     B = ones([state_num, observation_state_num]);
% %     B = B ./ (state_num*observation_state_num);
% %     B = zeros([state_num, observation_state_num]);
% %     B(:, 1) = 1;
%     
%     Pi = rand([state_num, 1]);
%     Pi = Pi ./ sum(Pi);
%     train_A{i} = A;
%     train_B{i} = B;
%     train_Pi{i} = Pi;   
% end

% 估算A，B，Pi
train_A = [];
train_B = [];
train_Pi = [];
for i =1:6
    observation_seq = train_observation_seq{i};
    state_seq = train_state_seq{i};
    [A,B,Pi] = get_state(observation_seq,state_seq,observation_state_num,state_num);
    train_A{i} = A;
    train_B{i} = B;
    train_Pi{i} = Pi;
end

%%
% 训练
for i =1:6
    seq = train_observation_seq{i};
    [new_A, new_B] = HMM_train(seq,train_Pi{i},train_A{i},train_B{i},500);
    train_A{i} = new_A;
    train_B{i} = new_B;
end

%%
% 测试
likelyhood = [];
for i = 1:6
    test_seq = test_observation_seq{i};
    [test_seq_len, ~] = size(test_seq);
    likelyhood{i} = [];
    for j = 1:test_seq_len
        [j, test_seq_len];
        seq = test_seq(j, :);
        seq_likelyhood = [];
        for k = 1:6
            [~, ~, scale] = HMM_decode(seq,train_Pi{k},train_A{k},train_B{k});
            logP = sum(log(scale));
            seq_likelyhood = [seq_likelyhood, logP];
        end
        likelyhood{i} = [likelyhood{i}; seq_likelyhood];
    end
end

C = zeros(6, 6);
test_label = [];
for i = 1:6
    sublikelyhood = likelyhood{i};
    [len, ~] = size(sublikelyhood);
    for j = 1:len
            [max_logP, max_index] = max(sublikelyhood(j, :));
            test_label = [test_label; [max_index, max_logP]];
            C(i, max_index) = C(i, max_index) + 1;
    end
end
C
trace(C) / sum(sum(C))

