function [state] = draw_rect_in_img(img,points,windows,show_or_not)
% 输入：
% img：图片数组
% point：框的左上角坐标[height_x,width_y]
% window：框的大小[height,width]
% show_or_not：是否显示，1为显示
% 输出：
% state画框是否成功，0失败，1成功

img_size = size(img);
points_size = size(points);
windows_size = size(windows);
color = 255;

if(points_size(1) ~= windows_size(1))
    state = 0
    return
end
if(length(img_size) == 2)
    copy_img = img(:, :);
else if(length(img_size) == 3)
        copy_img = img(:, :, :);
    end
end 

for i = 1:points_size(1)
%     copy_img = r_copy_img;
    point = points(i, :);
    window = windows(i, :);
    
    x = point(1);
    y = point(2);
    height = window(1);
    width = window(2);

    if(x<=1 || y<=1 || x+height>=img_size(1)-1 || y+width>=img_size(2)-1)
        '超出图片，跳过'
        continue
    end
%     figure(i)

    if(length(img_size) == 2)
        copy_img(x:x+height-1, y:y) = color;
        copy_img(x:x+height-1, y-1:y-1) = color;

        copy_img(x:x, y:y+width-1) = color;
        copy_img(x-1:x-1, y:y+width-1) = color;

        copy_img(x:x+height-1, y+width-1:y+width-1) = color;
        copy_img(x:x+height-1, y+width:y+width) = color;

        copy_img(x+height-1:x+height-1, y:y+width-1) = color;
        copy_img(x+height:x+height, y:y+width-1) = color;
    else if(length(img_size) == 3)
            copy_img(x:x+height-1, y:y, :) = color;
            copy_img(x:x+height-1, y-1:y-1, :) = color;

            copy_img(x:x, y:y+width-1, :) = color;
            copy_img(x-1:x-1, y:y+width-1, :) = color;

            copy_img(x:x+height-1, y+width-1:y+width-1, :) = color;
            copy_img(x:x+height-1, y+width:y+width, :) = color;

            copy_img(x+height-1:x+height-1, y:y+width-1, :) = color;
            copy_img(x+height:x+height, y:y+width-1, :) = color;
        end
    end
%     if(show_or_not == 1)
%         imagesc(copy_img);
%         axis equal
%         colormap('gray');
%     end
end

state = 1;
if(show_or_not == 1)
    imagesc(copy_img);
    axis equal
    colormap('gray');
end



end

