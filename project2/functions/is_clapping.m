function [state] = is_clapping(img)

[h w] = size(img);
r = 1/5;
subimg1 = img(1:round(w*r), 1:round(w*r));
subimg2 = img(1:round(w*r), end-round(w*r):end);

r1 = 1/3;
r2 = 1/10;
subimg3 = img(end-round(r1*h):end, 1:round(w*r2));
subimg4 = img(end-round(r1*h):end, end-round(w*r2):end);

p1 = find(subimg1 == 1);
p2 = find(subimg2 == 1);
p3 = find(subimg3 == 1);
p4 = find(subimg4 == 1);
if(length(p1) == 0 && length(p2) == 0 &&length(p3) == 0 &&length(p4) == 0)
    state = 3;
else
    state = 1;
%     point = [1, 1; 1, w-round(w*r); h-round(r1*h),1; h-round(r1*h),w-round(w*r2)];
%     window = [round(w*r), round(w*r);round(w*r),round(w*r);round(r1*h),round(w*r2);round(r1*h),round(w*r2)];
%     draw_rect_in_img(img,point,window,1)
end


end

