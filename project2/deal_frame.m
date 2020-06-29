
%%
video = all_video{2}{9};
frame_num = video.NumberOfFrames;
for i = 1:20
    ith_frame = read(video, i); % ��ȡ�ڼ�֡
    ith_frame = ith_frame(:, :, 1);
%     BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % ��ֵ��
    BW = imbinarize(ith_frame);
%     imagesc(BW)
    [m,n]=size(BW); 
    
    Y=dct2(BW); 
    I=zeros(m,n);
    I(1:round(m/3),1:round(n/3))=1;
    Ydct=Y.*I;
    Y=uint8(idct2(Ydct)); 
    
    se1=strel('disk',3);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
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
ith_frame = read(video, 15); % ��ȡ�ڼ�֡
ith_frame = ith_frame(:, :, 1);
BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % ��ֵ��
%     imagesc(BW)
[m,n]=size(BW); 
Y=dct2(BW); 
I=zeros(m,n);
I(1:round(m/3),1:round(n/3))=1;
Ydct=Y.*I;
Y=uint8(idct2(Ydct)); 
se1=strel('disk',3);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
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
% �Ҷ�ͼ
ith_frame = ith_frame(:, :, 1);
ith_frame = rgb2gray(ith_frame); % ��Ҷ�ͼ
BW = imbinarize(ith_frame); % ��ֵ��

%%
%perform morphological operations on thresholded image to eliminate noise
%and emphasize the filtered object(s)��������̬ѧ������ʴ�����͡��׶���䣩
dilateElement=strel('square',13) ;
threshold=imdilate(threshold1, dilateElement);
erodeElement = strel('square', 4) ;
threshold = imerode(threshold,erodeElement);
erodeElement = strel('square', 3) ;
threshold = imerode(threshold,erodeElement);
erodeElement = strel('square', 2) ;
threshold = imerode(threshold,erodeElement);
threshold=imfill(threshold,'holes');
subplot(2,2,4),imshow(threshold),title('��̬ѧ����');
%%
% matlab����ע��
%{
    erodeElement = strel('square', 2) ;
    dilateElement=strel('square',4) ;
    threshold = imerode(threshold,erodeElement);
    threshold = imerode(threshold,erodeElement);
    threshold=imdilate(threshold, dilateElement);
    threshold=imdilate(threshold, dilateElement);
    threshold=imfill(threshold,'holes');
    subplot(2,2,4),imshow(threshold),title('��̬ѧ����'),
 %}
%%
%��ȡ�����'basic'���ԣ� 'Area', 'Centroid', and 'BoundingBox' 
figure('name','������'),
stats = regionprops(threshold, 'basic');
[C,area_index]=max([stats.Area]);
%��λ�������
face_locate=[stats(area_index).Centroid(1),stats(area_index).Centroid(2)];
imshow(RGB);title('after'),hold on
text(face_locate(1),face_locate(2)-40,  'face','color','red');
plot(face_locate(1),face_locate(2), 'b*');
rectangle('Position',[stats(area_index).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r'),
hold off 

%������ͼƬƴ�ӳ�һ��������ͼ��
RGB= imresize(RGB ,[1800 2307],'nearest') ; % 'nearest'����ڲ�ֵ��Ĭ�ϣ�,'bilinear'˫���Բ�ֵ,'bicubic'˫���β�ֵ
YCBCR= imresize(YCBCR ,[1800 2307],'nearest') ; % 'nearest'����ڲ�ֵ��Ĭ�ϣ�,'bilinear'˫���Բ�ֵ,'bicubic'˫���β�ֵ
threshold1= imresize(threshold1 ,[1800 2307],'nearest') ;
threshold= imresize(threshold ,[1800 2307],'nearest') ;
figure
imshow([RGB,YCBCR]) %��������˼��,������Ҳ�����������Ԫ��
figure
imshow([threshold1,threshold]) 
t=toc

