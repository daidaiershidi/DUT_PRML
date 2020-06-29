%%
addpath .\functions
%%
% 读取recognition图片
recognition_image_path = 'project1-data-Recognition\project1-data-Recognition\';
recognition_pgm_files_list = dir(fullfile(recognition_image_path,'*.pgm'));

recognition_images = [];
recognition_images_labels = [];
recognition_images_num_labels = [];
for i = 1:length(recognition_pgm_files_list)
    file_name = recognition_pgm_files_list(i).name;
    s = regexp(file_name, '\.', 'split');
    
    label = char(s{2});
    image = imread(strcat(recognition_image_path, file_name));
    image_size = size(image);
    raw_image_height = image_size(1);
    raw_image_width = image_size(2);
    
    % 图片变成原来的1/16,并转变成1XN
    image = image(1:4:end, 1:4:end);
    image_reshape = image(:);
    [image_reshape_height, image_reshape_width] = size(image);
    recognition_images = [recognition_images; image_reshape'];
    recognition_images_labels{i} = label;
    recognition_images_num_labels = [recognition_images_num_labels; ceil(i/11)];
end
clear i s image_reshape image_size file_name label  recognition_image_path recognition_pgm_files_list

%%
% (b)
N = 3; % N <= 11
misclassify_rates = [];
for d_ = 1:1:14
    misclassify_rates_ = [];
    d_;
    for i = 1:10
        % 划分数据集
        [train_image,train_image_label,test_image,test_image_label] = get_N_data_in_each_subject(recognition_images, recognition_images_num_labels, N);
        % 用Fisherfaces和DA-Fisherfaces计算，并使用最近邻分类
        predict = get_fisherfaces_and_NN(train_image, train_image_label, test_image, d_);
%         predict = get_DA_fisherfaces_and_NN(train_image, train_image_label, test_image, d_);
        % 计算误判率
        misclassify_rate = calculate_misclassify_rate(predict, test_image_label);
        misclassify_rates_ = [misclassify_rates_, misclassify_rate];
    end
    misclassify_rates = [misclassify_rates; misclassify_rates_];
end
% 画图
misclassify_rates = sum(misclassify_rates, 2) ./ 10
plot(1:1:14, misclassify_rates')
misclassify_rates_X{N} = misclassify_rates';
%%
% (c)
for N = [5, 7]
    misclassify_rates = [];
    for d_ = 1:1:14
        d_
        misclassify_rates_ = [];
        for i = 1:10
            % 划分数据集
            [train_image,train_image_label,test_image,test_image_label] = get_N_data_in_each_subject(recognition_images, recognition_images_num_labels, N);
            % 用Fisherfaces和DA-Fisherfaces计算，并使用最近邻分类
            predict = get_fisherfaces_and_NN(train_image, train_image_label, test_image, d_);
%             predict = get_DA_fisherfaces_and_NN(train_image, train_image_label, test_image, d_);
            % 计算误判率
            misclassify_rate = calculate_misclassify_rate(predict, test_image_label);
            misclassify_rates_ = [misclassify_rates_, misclassify_rate];
        end
        misclassify_rates = [misclassify_rates; misclassify_rates_];
    end
    % 画图
    misclassify_rates = sum(misclassify_rates, 2) ./ 10
    plot(1:1:14, misclassify_rates')
    misclassify_rates_X{N} = misclassify_rates';
end
%%
% 画图
data = [];
for i = [3, 5, 7]
    data = [data; misclassify_rates_X{i}];
    plot(1:1:14, misclassify_rates_X{i});
    hold on
end
legend('N=3', 'N=5', 'N=7');
hold off
xlswrite('fisherfaces_misclassify_rate.xlsx', data)