%%
addpath .\functions
%%
% ��ȡrecognitionͼƬ
recognition_image_path = 'project1-data-Recognition\project1-data-Recognition\';
recognition_pgm_files_list = dir(fullfile(recognition_image_path,'*.pgm'));

recognition_images = [];
for i = 1:length(recognition_pgm_files_list)
    file_name = recognition_pgm_files_list(i).name;
    recognition_image = imread(strcat(recognition_image_path, file_name));
    % ͼƬ���ԭ����1/16
    recognition_image = recognition_image(1:4:end, 1:4:end);
    recognition_image_size = size(recognition_image);
    recognition_image_height = recognition_image_size(1);
    recognition_image_width = recognition_image_size(2);
    % ת���1XN
    image_vector = reshape(recognition_image, 1, recognition_image_size(1)*recognition_image_size(2));
    recognition_images = [recognition_images; image_vector];
end
% clear i s image image_reshape image_size file_name label  recognition_image_path recognition_pgm_files_list

%%
% ��ѵ��ͼƬ����PCA������ֵ��x��ά�ȣ�y�ǵ�1��x������ֵ���ܺ͡�
[~, ~, sorted_Langdas] = PCA(recognition_images, 2842);
x = [];
y = [];
for i = 1:2842
    x = [x, i];
    y = [y, sum(sorted_Langdas(1,1:i))];
end
max_y = max(y);
index = find(y(1, :) >= 0.95 * max_y);
x(index(1))
plot(x, y)