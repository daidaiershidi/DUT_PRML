function [indexs,disp_window] = show_image_after_detection(image,x,y,s,window_num,window_size)
% 输入：
% image，待检测图片，3通道或灰度图
% x，y，s：[x, y]是滑动窗口的左上角坐标，s是窗口图片与训练集的平均距离
% window_num：按照距离从小到大显示几个窗口
% window_size：窗口大小
% 输出：
% disp：[x,y,s]图片上显示的窗口的信息
% indexs：[x,y,s]在全部[x,y,s]里的序号

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

