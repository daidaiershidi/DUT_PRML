%%
addpath .\functions
%%
% (a)
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
    
    % 转变成1XN
    image_reshape = reshape(image, 1, image_size(1)*image_size(2));
    recognition_images = [recognition_images; image_reshape];
    recognition_images_labels{i} = label;
    recognition_images_num_labels = [recognition_images_num_labels; ceil(i/11)];
end
clear i s image image_reshape image_size file_name label  recognition_image_path recognition_pgm_files_list
%%
% 划分数据集
N = 10;
[train_image,train_image_label,test_image,test_image_label] = get_N_data_in_each_subject(recognition_images, recognition_images_num_labels, N);
% 显示平均脸
mean_face = mean(train_image);
imagesc(reshape(mean_face, raw_image_height, raw_image_width));
axis equal
title('Mean face');
colormap('gray');
%%
% 显示特征脸
d_ = 15;
mean_face = mean(train_image);
[pcaX, eigenfaces] = fastPCA(train_image, d_);
figure;
num_eigenfaces_show = 9;
for i = 1:num_eigenfaces_show
	subplot(3, 3, i)
	imagesc(reshape(eigenfaces(:, i), raw_image_height, raw_image_width));
	title(['Eigenfaces ' num2str(i)]);
    axis equal
end
colormap('gray');
%%
% (b)
N = 3; % N <= 11
misclassify_rates = [];
for d_ = 1:15*N
    d_
    misclassify_rates_ = [];
    for i = 1:10
        [train_image,train_image_label,test_image,test_image_label] = get_N_data_in_each_subject(recognition_images, recognition_images_num_labels, N);
        % 计算eigenfaces并进行NN预测
        % d_ = 90; % d_ <= 15*N
        predict = get_eigenfaces_and_NN(train_image, train_image_label, test_image, d_);
        % 计算误判率
        misclassify_rate = calculate_misclassify_rate(predict, test_image_label);
        misclassify_rates_ = [misclassify_rates_, misclassify_rate];
    end
    misclassify_rates = [misclassify_rates; misclassify_rates_];
end
% 画图
misclassify_rates = sum(misclassify_rates, 2) ./ 10
plot(1:1:15*N, misclassify_rates')
misclassify_rates_X{N} = misclassify_rates';
%%
% (c)
for N = [5, 7]
    misclassify_rates = [];
    for d_ = 1:15*N
        d_
        misclassify_rates_ = [];
        for i = 1:10
            [train_image,train_image_label,test_image,test_image_label] = get_N_data_in_each_subject(recognition_images, recognition_images_num_labels, N);
            % 计算eigenfaces并进行NN预测
            % d_ = 90; % d_ <= 15*N
            predict = get_eigenfaces_and_NN(train_image, train_image_label, test_image, d_);
            % 计算误判率
            misclassify_rate = calculate_misclassify_rate(predict, test_image_label);
            misclassify_rates_ = [misclassify_rates_, misclassify_rate];
        end
        misclassify_rates = [misclassify_rates; misclassify_rates_];
    end
    % 画图
    misclassify_rates = sum(misclassify_rates, 2) ./ 10
    plot(1:1:15*N, misclassify_rates')
    misclassify_rates_X{N} = misclassify_rates';
end
%%
% 画图
for i = [3, 5, 7]
    plot(1:1:15*i, misclassify_rates_X{i});
    hold on
end
legend('N=3', 'N=5', 'N=7');
hold off
m = [misclassify_rates_X{3}([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,20,25,30,35,40]);misclassify_rates_X{5}([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,20,25,30,35,40]);misclassify_rates_X{7}([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,20,25,30,35,40])];
xlswrite('eigenfaces_misclassify_rate.xlsx', m)