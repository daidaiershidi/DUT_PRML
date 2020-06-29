%%
addpath .\functions
%%
recognition_image_path = 'project1-data-Recognition\project1-data-Recognition\';
recognition_pgm_files_list = dir(fullfile(recognition_image_path,'*.pgm'));
% 读取recognition图片
train_images = [];
for i = 1:length(recognition_pgm_files_list)
    
    
    % 得到第i张图片
    file_name = recognition_pgm_files_list(i).name;
    ith_image = imread(strcat(recognition_image_path, file_name));
    ith_image = ith_image(1:1:end, 1:1:end);
    
    % 记录训练图片原始大小
    train_image_size = size(ith_image);
  
    
%     训练图片预处理
%     预处理LBP
    ith_image = LBP(ith_image);
    
    % 转变成1XN
    image_vector = reshape(ith_image, 1, train_image_size(1)*train_image_size(2));
    train_images = [train_images; image_vector];
end
% clear i s image image_reshape image_size file_name label  recognition_image_path recognition_pgm_files_list


%%
% 读取全部detection图片名
detection_image_path = 'project1-data-Detection\project1-data-Detection\';
detection_jpg_files_list = dir(fullfile(detection_image_path,'*.jpg'));


%%
% 读取第一张图片
file_name = detection_jpg_files_list(1).name;
first_image = imread(strcat(detection_image_path, file_name));
% 窗口大小（训练图片[231,195]，为了不改变人类的比例，窗口选为[23*n,15*n]）
n = 18;
window_size = [23*n, 19*n];
% 检测
[distances,resize_image,x, y, s] = detection_in_fixed_size_window(first_image,window_size,train_images,train_image_size);
% 显示
%%
% image = LBP(resize_image);
[indexs,disp_window] = show_image_after_detection(resize_image,x,y,s,1,train_image_size);






%%
% 读取第二张图片
file_name = detection_jpg_files_list(2).name;
second_image = imread(strcat(detection_image_path, file_name));
% 窗口大小
n = 4;
window_size = ceil([23*n, 19*n]);
% 检测
[distances,resize_image, x, y, s] = detection_in_fixed_size_window(second_image,window_size,train_images,train_image_size);
% 显示
%%
% image = LBP(resize_image);
[indexs,disp_window] = show_image_after_detection(resize_image,x,y,s,2,train_image_size);




%%
% 读取第三张图片
file_name = detection_jpg_files_list(3).name;
third_image = imread(strcat(detection_image_path, file_name));
% 窗口大小
n = 2.5;
window_size = int32([23*n, 19*n]);
% 检测
[distances,resize_image, x, y, s] = detection_in_fixed_size_window(third_image,window_size,train_images,train_image_size);
% 显示
%%
% image = LBP(resize_image);
[indexs,disp_window] = show_image_after_detection(resize_image,x,y,s,75,train_image_size);

%%
% %%
% 调参
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
% 试了试VJ框架
faceDetector = vision.CascadeObjectDetector();
file_name = detection_jpg_files_list(3).name;
img = imread(strcat(detection_image_path, file_name));
videoFrame = rgb2gray(img);
bbox = step(faceDetector, img);
% 显示
videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
imshow(videoOut)
title('Detected face');



