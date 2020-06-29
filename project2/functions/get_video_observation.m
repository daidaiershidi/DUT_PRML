% function [xyt] = get_video_observation(video, observation_state_num)
% % VideoReader返回参数结构：
% % Name - -视频文件名 
% % Path – 视频文件路径 
% % Duration – 视频的总时长（秒） 
% % FrameRate - -视频帧速（帧/秒） 
% % NumberOfFrames – 视频的总帧数 
% % Height – 视频帧的高度 
% % Width – 视频帧的宽度 
% % BitsPerPixel – 视频帧每个像素的数据长度（比特） 
% % VideoFormat – 视频的类型, 如 ‘RGB24’. 
% % Tag – 视频对象的标识符，默认为空字符串” 
% % Type – 视频对象的类名，默认为’VideoReader’.
% 
% frame_num = video.NumberOfFrames; % 视频总帧数
% 
% x = [];
% y = [];
% h = [];
% w = [];
% t = [];
% frame_vocter = [];
% xyt = [];
% for i = 1:frame_num
%     ith_frame = read(video, i); % 读取第i帧
%     % 灰度图
%     ith_frame = ith_frame(:, :, 1);
%     % 二值化
%     BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % 二值化
%     % 高频去噪
%     [m,n]=size(BW); 
%     Y=dct2(BW); 
%     I=zeros(m,n);
%     I(1:round(m/3),1:round(n/3))=1;
%     Ydct=Y.*I;
%     BW=uint8(idct2(Ydct)); 
%     % 腐蚀
%     se1=strel('disk',3);%这里是创建一个半径为5的平坦型圆盘结构元素
%     BW = imerode(BW, se1);
%     % 提取边缘
%     BW = bwperim(BW);
%     BW = BW(2:end-1, 2:end-1);
% %     imagesc(BW)
%     % 得到所有人体像素位置
%     [r, c] = find(BW == 1);
%     % 获得N等分点(N-1对)
%     if(length(r)~=0 && length(c)~=0)
%         xyt = [xyt; mean(r), mean(c), i]; 
% %         N = 4;
% %         start = min(r);
% %         len = (max(r) - min(r)) / N;
% %         coord_vocter = [];
% %         for j = 1:N-1
% %             coord = start + round(len * j);
% %             coord_r = find(Y(coord, :) == 1);
% %             coord_vocter = [coord_vocter; coord, min(coord_r)];
% %             coord_vocter = [coord_vocter; coord, max(coord_r)];
% %         end
% %         frame_vocter = [frame_vocter; coord_vocter(:)'];
% %         t = [t; i];
%     end
%     
%     
% end
% % frame_vocter
% % size(frame_vocter)
% % [pcaX, ~] = fastPCA(frame_vocter, 1);
% % LLE_X = LLE(frame_vocter', 5, 2);
% 
% % xyt = [pcaX(:, 1), t];
% 
% 
% end
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [s] = get_video_observation(video)
% VideoReader返回参数结构：
% Name - -视频文件名 
% Path – 视频文件路径 
% Duration – 视频的总时长（秒） 
% FrameRate - -视频帧速（帧/秒） 
% NumberOfFrames – 视频的总帧数 
% Height – 视频帧的高度 
% Width – 视频帧的宽度 
% BitsPerPixel – 视频帧每个像素的数据长度（比特） 
% VideoFormat – 视频的类型, 如 ‘RGB24’. 
% Tag – 视频对象的标识符，默认为空字符串” 
% Type – 视频对象的类名，默认为’VideoReader’.

frame_num = video.NumberOfFrames; % 视频总帧数

observation_seq = [];
for i = 1:20
    ith_frame = read(video, i); % 读取第i帧
    % 灰度图
    ith_frame = ith_frame(:, :, 1);
    % 二值化
    BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % 二值化
    % 高频去噪
    [m,n]=size(BW); 
    Y=dct2(BW); 
    I=zeros(m,n);
    I(1:round(m/3),1:round(n/3))=1;
    Ydct=Y.*I;
    BW=uint8(idct2(Ydct)); 
    % 腐蚀
    se1=strel('disk',3);%这里是创建一个半径为5的平坦型圆盘结构元素
    BW = imerode(BW, se1);
    % 提取边缘
    BW = bwperim(BW);
    BW = BW(2:end-1, 2:end-1);
    [h, w] = size(BW);
    
    figure(i)
    imagesc(BW)
    state = -1;
    
    
    % 获得状态和子图
    [r, c] = find(BW == 1);
    BW = BW(min(r):max(r), min(c):max(c));
    
    %非空
    if(length(r)~=0 && length(c)~=0 && max(c)==w) 
        state = is_boxing(BW);
        %boxing
        if(state == 1)
            state = is_clapping(BW);
            %clapping
            if(state == 1)
                state = is_waving(BW);
                %waving
                if(state == 1)
                    observation_seq = [observation_seq, state];
                end          
            %clapping
            else
                observation_seq = [observation_seq, state];
            end
        %boxing
        else
            observation_seq = [observation_seq, state];
        end  
    %非空
    end
    
    
%     [i, state]
end
one_num = find(observation_seq == 1);
s = length(one_num) / length(observation_seq);
end


