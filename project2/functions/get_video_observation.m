% function [xyt] = get_video_observation(video, observation_state_num)
% % VideoReader���ز����ṹ��
% % Name - -��Ƶ�ļ��� 
% % Path �C ��Ƶ�ļ�·�� 
% % Duration �C ��Ƶ����ʱ�����룩 
% % FrameRate - -��Ƶ֡�٣�֡/�룩 
% % NumberOfFrames �C ��Ƶ����֡�� 
% % Height �C ��Ƶ֡�ĸ߶� 
% % Width �C ��Ƶ֡�Ŀ�� 
% % BitsPerPixel �C ��Ƶ֡ÿ�����ص����ݳ��ȣ����أ� 
% % VideoFormat �C ��Ƶ������, �� ��RGB24��. 
% % Tag �C ��Ƶ����ı�ʶ����Ĭ��Ϊ���ַ����� 
% % Type �C ��Ƶ�����������Ĭ��Ϊ��VideoReader��.
% 
% frame_num = video.NumberOfFrames; % ��Ƶ��֡��
% 
% x = [];
% y = [];
% h = [];
% w = [];
% t = [];
% frame_vocter = [];
% xyt = [];
% for i = 1:frame_num
%     ith_frame = read(video, i); % ��ȡ��i֡
%     % �Ҷ�ͼ
%     ith_frame = ith_frame(:, :, 1);
%     % ��ֵ��
%     BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % ��ֵ��
%     % ��Ƶȥ��
%     [m,n]=size(BW); 
%     Y=dct2(BW); 
%     I=zeros(m,n);
%     I(1:round(m/3),1:round(n/3))=1;
%     Ydct=Y.*I;
%     BW=uint8(idct2(Ydct)); 
%     % ��ʴ
%     se1=strel('disk',3);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
%     BW = imerode(BW, se1);
%     % ��ȡ��Ե
%     BW = bwperim(BW);
%     BW = BW(2:end-1, 2:end-1);
% %     imagesc(BW)
%     % �õ�������������λ��
%     [r, c] = find(BW == 1);
%     % ���N�ȷֵ�(N-1��)
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
% VideoReader���ز����ṹ��
% Name - -��Ƶ�ļ��� 
% Path �C ��Ƶ�ļ�·�� 
% Duration �C ��Ƶ����ʱ�����룩 
% FrameRate - -��Ƶ֡�٣�֡/�룩 
% NumberOfFrames �C ��Ƶ����֡�� 
% Height �C ��Ƶ֡�ĸ߶� 
% Width �C ��Ƶ֡�Ŀ�� 
% BitsPerPixel �C ��Ƶ֡ÿ�����ص����ݳ��ȣ����أ� 
% VideoFormat �C ��Ƶ������, �� ��RGB24��. 
% Tag �C ��Ƶ����ı�ʶ����Ĭ��Ϊ���ַ����� 
% Type �C ��Ƶ�����������Ĭ��Ϊ��VideoReader��.

frame_num = video.NumberOfFrames; % ��Ƶ��֡��

observation_seq = [];
for i = 1:20
    ith_frame = read(video, i); % ��ȡ��i֡
    % �Ҷ�ͼ
    ith_frame = ith_frame(:, :, 1);
    % ��ֵ��
    BW = imbinarize(ith_frame,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); % ��ֵ��
    % ��Ƶȥ��
    [m,n]=size(BW); 
    Y=dct2(BW); 
    I=zeros(m,n);
    I(1:round(m/3),1:round(n/3))=1;
    Ydct=Y.*I;
    BW=uint8(idct2(Ydct)); 
    % ��ʴ
    se1=strel('disk',3);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
    BW = imerode(BW, se1);
    % ��ȡ��Ե
    BW = bwperim(BW);
    BW = BW(2:end-1, 2:end-1);
    [h, w] = size(BW);
    
    figure(i)
    imagesc(BW)
    state = -1;
    
    
    % ���״̬����ͼ
    [r, c] = find(BW == 1);
    BW = BW(min(r):max(r), min(c):max(c));
    
    %�ǿ�
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
    %�ǿ�
    end
    
    
%     [i, state]
end
one_num = find(observation_seq == 1);
s = length(one_num) / length(observation_seq);
end


