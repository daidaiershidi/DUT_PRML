%%
addpath .\functions
%%
recognition_image_path = 'project1-data-Recognition\project1-data-Recognition\';
recognition_pgm_files_list = dir(fullfile(recognition_image_path,'*.pgm'));
% ��ȡrecognitionͼƬ
train_images = [];
for i = 1:length(recognition_pgm_files_list)
    
    
    % �õ���i��ͼƬ
    file_name = recognition_pgm_files_list(i).name;
    ith_image = imread(strcat(recognition_image_path, file_name));
    ith_image = ith_image(1:1:end, 1:1:end);
    
    % ��¼ѵ��ͼƬԭʼ��С
    train_image_size = size(ith_image);
  
    
%     ѵ��ͼƬԤ����
%     Ԥ����LBP
    ith_image = LBP(ith_image);
    
    % ת���1XN
    image_vector = reshape(ith_image, 1, train_image_size(1)*train_image_size(2));
    train_images = [train_images; image_vector];
end
% clear i s image image_reshape image_size file_name label  recognition_image_path recognition_pgm_files_list


%%
% ��ȡȫ��detectionͼƬ��
detection_image_path = 'project1-data-Detection\project1-data-Detection\';
detection_jpg_files_list = dir(fullfile(detection_image_path,'*.jpg'));


%%
% ��ȡ��һ��ͼƬ
file_name = detection_jpg_files_list(1).name;
first_image = imread(strcat(detection_image_path, file_name));
% ���ڴ�С��ѵ��ͼƬ[231,195]��Ϊ�˲��ı�����ı���������ѡΪ[23*n,15*n]��
n = 18;
window_size = [23*n, 19*n];
% ���
[distances,resize_image,x, y, s] = detection_in_fixed_size_window(first_image,window_size,train_images,train_image_size);
% ��ʾ
%%
% image = LBP(resize_image);
[indexs,disp_window] = show_image_after_detection(resize_image,x,y,s,1,train_image_size);






%%
% ��ȡ�ڶ���ͼƬ
file_name = detection_jpg_files_list(2).name;
second_image = imread(strcat(detection_image_path, file_name));
% ���ڴ�С
n = 4;
window_size = ceil([23*n, 19*n]);
% ���
[distances,resize_image, x, y, s] = detection_in_fixed_size_window(second_image,window_size,train_images,train_image_size);
% ��ʾ
%%
% image = LBP(resize_image);
[indexs,disp_window] = show_image_after_detection(resize_image,x,y,s,2,train_image_size);




%%
% ��ȡ������ͼƬ
file_name = detection_jpg_files_list(3).name;
third_image = imread(strcat(detection_image_path, file_name));
% ���ڴ�С
n = 2.5;
window_size = int32([23*n, 19*n]);
% ���
[distances,resize_image, x, y, s] = detection_in_fixed_size_window(third_image,window_size,train_images,train_image_size);
% ��ʾ
%%
% image = LBP(resize_image);
[indexs,disp_window] = show_image_after_detection(resize_image,x,y,s,75,train_image_size);

%%
% %%
% ����
% for i = 1:20
%     ll = i/10+2;
%     lll = 1.0e+8 * ll;
%     al = length(find(a < lll));
%     bl = length(find(b < lll));
%     cl = length(find(c < lll));
%     [ll, al, bl, abs(al-bl), cl]
% 
% end


%%
% ������VJ���
faceDetector = vision.CascadeObjectDetector();
file_name = detection_jpg_files_list(3).name;
img = imread(strcat(detection_image_path, file_name));
videoFrame = rgb2gray(img);
bbox = step(faceDetector, img);
% ��ʾ
videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
imshow(videoOut)
title('Detected face');



