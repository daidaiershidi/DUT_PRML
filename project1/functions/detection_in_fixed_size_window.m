function [distances,resize_image,x,y,socre] = detection_in_fixed_size_window(image, window_size, train_iamge, train_image_size) % fisherfaces_size
% ���룺
% image��������ͼƬ��size = [H, W]
% window_size����ⴰ�ڴ�С
% train_iamge��ѵ��ͼƬ���ݼ���ÿ��һ��ͼƬ
% train_image_size��ѵ��ͼƬ��С
% W_fld
% �����
% distances������
% resize_image���仯���ͼƬ
% x����
% y����
% score������

% ͼƬ��Ϊ�Ҷ�ͼ
image_size = size(image);
if(length(image_size) == 3)
    image = rgb2gray(image);
end

% �õ������ͼƬ��С����ⴰ�ڴ�С
image_height = image_size(1);
image_width = image_size(2);

window_height = window_size(1);
window_width = window_size(2);

train_image_height = train_image_size(1);
train_image_width = train_image_size(2);


% �õ�ѵ�����ݼ�PCAͶӰ����
mean_face = mean(train_iamge);
[W, W_pca] = fastPCA(train_iamge, 65);
% [W, W_fld] = FLD(pcaX, 15, 14);
% W = (Z * W_pca)';

% �����ͼƬԤ����
resize_image = imresize(image, ceil([image_height*(train_image_height/window_height),image_width*(train_image_width/window_width)]));
size(resize_image)
% image = gray_normalization(image); % ��ֵ��һ��
image = LBP(resize_image); % LBP

socre = [];
x = [];
y = [];

% ԭͼƬ��С/Ԥ��������ţ���ͼƬ��С == ���ڴ�С/ѵ��ͼƬ��С
% ������Ԥ�������Ҫ����ͼƬ��С�ʹ��ڴ�С
window_height = train_image_height;
window_width = train_image_width;

image_size = size(image);
image_height = image_size(1);
image_width = image_size(2);


distances = [];
for i = 1 : round(window_height/8) : (image_height - window_height + 1) 
    [i, image_height - window_height + 1]
    for j = 1 : round(window_width/8) : image_width - window_width + 1
        % ȡ��
        subimage = image(i:i+window_height-1, j:j+window_width-1);
        subimage_vector = reshape(subimage, 1, window_height*window_width);

        % ����fisherfaces
        p = double(subimage_vector) - mean_face;
        W_new = (p * W_pca);
        
        % NN����
        distance = sum((W - W_new).^2, 2)'; % L2����
%         distance = sum((W' - W_new'), 2); % L1����
        index1 = find(distance < 1.0e+8 * 2.2);
        index2 = find(distance < 1.0e+8 * 2.6);
        index3 = find(distance < 1.0e+8 * 2.5);
        index4 = find(distance < 1.0e+8 * 2.3);
        index5 = find(distance < 1.0e+8 * 2.1);
        index6 = find(distance < 1.0e+8 * 2.4);
%         index7 = find(distance < 1.0e+8 * 2.8);
        index7 = find(distance < 1.0e+8 * 3.1);
        index8 = find(distance < 1.0e+8 * 3.2);
        index9 = find(distance < 1.0e+8 * 2.7);
        
        
        
        if(length(index1)<20 && length(index2)<91 && length(index3) > 59 && length(index3)<68 && length(index4)<41 && length(index5)<15 && length(index6)<54 && length(index7)<149 && length(index8)<152 && length(index9)<113)% && length()<129
            score = mean(distance);
            x= [x; i];
            y= [y; j];
            socre= [socre; score];
            distances = [distances; distance];
        end
    end
end


end

