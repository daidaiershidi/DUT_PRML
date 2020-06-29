function [state] = is_boxing(img)

r1 = 1/3;
r2 = 1/4;
n = 5;
[h w] = size(img);
subimg1 = img(1:round(w*r1), 1:round(w*r1));

d = round(h/2)-n;
if(d < 1)
    d = 1;
end
subimg2 = img(d:round(h/2)+n, 1:round(w*r2));
subimg3 = img(1:round(h/2)+n, 1:round(w*r2));
p1 = find(subimg1 == 1);
p2 = find(subimg2 == 1);
p3 = find(subimg3 == 1);
if(length(p1) == 0  &&  length(p2) == 0  && length(p3) ~= 0)
    state = 2;
%     point = [1, 1; round(h/2)-n, 1];
%     window = [round(w*r1), round(w*r1); 2*n, round(w*r2)];
%     draw_rect_in_img(img,point,window,1);
else
    state = 1;
end


end

