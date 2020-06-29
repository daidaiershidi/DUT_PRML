function [indexs,disp_window] = show_image_after_detection(image,x,y,s,window_num,window_size)
% ���룺
% image�������ͼƬ��3ͨ����Ҷ�ͼ
% x��y��s��[x, y]�ǻ������ڵ����Ͻ����꣬s�Ǵ���ͼƬ��ѵ������ƽ������
% window_num�����վ����С������ʾ��������
% window_size�����ڴ�С
% �����
% disp��[x,y,s]ͼƬ����ʾ�Ĵ��ڵ���Ϣ
% indexs��[x,y,s]��ȫ��[x,y,s]������

[sscore, sindex] = sort(s); % descend

startPosition = [];
window = [];
disp_window = [];
indexs = [];
for i = 1:window_num
    index = sindex(i);
    indexs = [indexs; index];
    startPosition = [startPosition; x(index), y(index)];
    t = [x(index), y(index), sscore(i)];
    disp_window = [disp_window; t];
    window = [window; window_size];
end
disp_window
draw_rect_in_img(image,startPosition,window,1)

end

