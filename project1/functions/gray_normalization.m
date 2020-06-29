function [gray_image] = gray_normalization(gray_image)
% https://blog.csdn.net/qq_15971883/article/details/85050205

% 灰度变换归一化
% gray_image = double(gray_image);
% max_vlaue = max(gray_image);
% min_vlaue = min(gray_image);
% gray_image = (gray_image - min_vlaue) ./ (max_vlaue - min_vlaue) .* 255;

% % 均值方差归一化
m0 = 127;
v0 = 0.1;
[gray_image_height, gray_image_width] = size(gray_image);
gray_image = double(gray_image);
m = mean(gray_image);
v = sum((gray_image - m) .^ 2) / length(gray_image);

new_gray_image = [];
for i = 1:gray_image_height
    new_gray_image_ = [];
    for j = 1:gray_image_width
        I = gray_image(i, j);
        if(I > m)
            fix = m0 + sqrt(  v0  *  ( ((I - m).^2)/v )     );
            new_gray_image_ = [new_gray_image_, fix];
        else
            fix = m0 - sqrt(  v0  *  ( ((I - m).^2)/v )     );
            new_gray_image_ = [new_gray_image_, fix];
        end
    end
    new_gray_image = [new_gray_image; new_gray_image_];
end
gray_image = new_gray_image;

end

