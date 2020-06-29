function [lbp_image] = LBP(gray_image)


[gray_image_height,gray_image_width,channel] = size(gray_image);
if channel==3
    gray_image = rgb2gray(gray_image);
end
lbp_image = uint8(zeros([gray_image_height gray_image_width]));
for i = 2:gray_image_height-1
    for j = 2:gray_image_width-1
        neighbor = [gray_image(i-1,j-1) gray_image(i-1,j) gray_image(i-1,j+1) gray_image(i,j+1) gray_image(i+1,j+1) gray_image(i+1,j) gray_image(i+1,j-1) gray_image(i,j-1)] > gray_image(i,j);
        pixel = 0;
        for k = 1:8
            pixel = pixel + neighbor(1,k) * bitshift(1,8-k);
        end
        lbp_image(i,j) = uint8(pixel);
    end
end


end

