function [gray_image]=rgb2gray(rgb_image)
% 输入：
% rgb_image：3通道RGB图片
% 输出：
% gray_image：单通道灰度图

[height,width,channel]=size(rgb_image);
for i=1:height
    for j=1:width
        for k=1:channel        
            gray_image(i,j,k)=0.299*rgb_image(i,j,1)+0.587*rgb_image(i,j,2)+0.11400*rgb_image(i,j,3);
        end
    end
end
gray_image = gray_image(:,:,1);

end
