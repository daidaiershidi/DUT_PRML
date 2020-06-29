
%%
video = all_video{2}{9};
frame_num = video.NumberOfFrames;
for i = 1:20
    ith_frame = read(video, i); % 读取第几帧
    ith_frame = ith_frame(:, :, 1);
%     BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % 二值化
    BW = imbinarize(ith_frame);
%     imagesc(BW)
    [m,n]=size(BW); 
    
    Y=dct2(BW); 
    I=zeros(m,n);
    I(1:round(m/3),1:round(n/3))=1;
    Ydct=Y.*I;
    Y=uint8(idct2(Ydct)); 
    
    se1=strel('disk',3);%这里是创建一个半径为5的平坦型圆盘结构元素
    Y=imerode(Y,se1);
    
    Y= bwperim(Y);
    Y = Y(2:end-1, 2:end-1);
    
    figure(i)
    imagesc(Y)
    [r, c] = find(Y == 1);
    Y = Y(min(r):max(r), min(c):max(c));
    a = is_clapping(Y);
    [i, a]
%     figure(i)
%     imagesc(Y)
%     [ar, ac] = find(Y == 1);
%     min_ar = min(ar);
%     max_ar = max(ar);
%     min_ac = min(ac);
%     max_ac = max(ac);
%     sY = Y(min_ar:max_ar, min_ac:max_ac);
    
%     if(state1 == 1)
%         figure(i)
%         imagesc(Y)
%     end
   
end
%%
video = all_video{5}{2};
frame_num = video.NumberOfFrames;
ith_frame = read(video, 15); % 读取第几帧
ith_frame = ith_frame(:, :, 1);
BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % 二值化
%     imagesc(BW)
[m,n]=size(BW); 
Y=dct2(BW); 
I=zeros(m,n);
I(1:round(m/3),1:round(n/3))=1;
Ydct=Y.*I;
Y=uint8(idct2(Ydct)); 
se1=strel('disk',3);%这里是创建一个半径为5的平坦型圆盘结构元素
Y=imerode(Y,se1);
Y= bwperim(Y);
Y = Y(2:end-1, 2:end-1);
imagesc(Y)
[ar, ac] = find(Y == 1);
min_ar = min(ar);
max_ar = max(ar);
min_ac = min(ac);
max_ac = max(ac);
sY = Y(min_ar:max_ar, min_ac:max_ac);
draw_rect_in_img(Y,[min_ar, min_ac],[max_ar-min_ar,max_ac-min_ac],1)















%%
% 灰度图
ith_frame = ith_frame(:, :, 1);
ith_frame = rgb2gray(ith_frame); % 变灰度图
BW = imbinarize(ith_frame); % 二值化

%%
%perform morphological operations on thresholded image to eliminate noise
%and emphasize the filtered object(s)（进行形态学处理：腐蚀、膨胀、孔洞填充）
dilateElement=strel('square',13) ;
threshold=imdilate(threshold1, dilateElement);
erodeElement = strel('square', 4) ;
threshold = imerode(threshold,erodeElement);
erodeElement = strel('square', 3) ;
threshold = imerode(threshold,erodeElement);
erodeElement = strel('square', 2) ;
threshold = imerode(threshold,erodeElement);
threshold=imfill(threshold,'holes');
subplot(2,2,4),imshow(threshold),title('形态学处理');
%%
% matlab多行注释
%{
    erodeElement = strel('square', 2) ;
    dilateElement=strel('square',4) ;
    threshold = imerode(threshold,erodeElement);
    threshold = imerode(threshold,erodeElement);
    threshold=imdilate(threshold, dilateElement);
    threshold=imdilate(threshold, dilateElement);
    threshold=imfill(threshold,'holes');
    subplot(2,2,4),imshow(threshold),title('形态学处理'),
 %}
%%
%获取区域的'basic'属性， 'Area', 'Centroid', and 'BoundingBox' 
figure('name','处理结果'),
stats = regionprops(threshold, 'basic');
[C,area_index]=max([stats.Area]);
%定位马的区域
face_locate=[stats(area_index).Centroid(1),stats(area_index).Centroid(2)];
imshow(RGB);title('after'),hold on
text(face_locate(1),face_locate(2)-40,  'face','color','red');
plot(face_locate(1),face_locate(2), 'b*');
rectangle('Position',[stats(area_index).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r'),
hold off 

%将五张图片拼接成一张完整的图像
RGB= imresize(RGB ,[1800 2307],'nearest') ; % 'nearest'最近邻插值（默认）,'bilinear'双线性插值,'bicubic'双三次插值
YCBCR= imresize(YCBCR ,[1800 2307],'nearest') ; % 'nearest'最近邻插值（默认）,'bilinear'双线性插值,'bicubic'双三次插值
threshold1= imresize(threshold1 ,[1800 2307],'nearest') ;
threshold= imresize(threshold ,[1800 2307],'nearest') ;
figure
imshow([RGB,YCBCR]) %面向对象的思想,将对象也当做最特殊的元素
figure
imshow([threshold1,threshold]) 
t=toc

