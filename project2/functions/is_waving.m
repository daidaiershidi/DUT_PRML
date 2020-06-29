function [state] = is_waving(img)

[h w] = size(img);
r1 = 1/4;
r2 = 1/10;
subimg1 = img(1:round(w*r2), 1:round(w*r1));
subimg2 = img(1:round(w*r2), end-round(w*r1):end);

r3 = 1/2;
r4 = 1/8;
subimg3 = img(end-round(r3*h):end, 1:round(w*r4));
subimg4 = img(end-round(r3*h):end, end-round(w*r4):end);

p1 = find(subimg1 == 1);
p2 = find(subimg2 == 1);
p3 = find(subimg3 == 1);
p4 = find(subimg4 == 1);
if(length(p1) == 0 && length(p2) == 0 &&length(p3) == 0 &&length(p4) == 0)
    state = 4;
%     point = [1, 1; 1, w-round(w*r1); h-round(r3*h),1; h-round(r3*h),w-round(w*r4)];
%     window = [round(w*r2), round(w*r1);round(w*r2),round(w*r1);round(r3*h),round(w*r4);round(r3*h),round(w*r4)];
%     draw_rect_in_img(img,point,window,1);
else
    state = 1;
%     point = [1, 1; 1, w-round(w*r1); h-round(r3*h),1; h-round(r3*h),w-round(w*r4)];
%     window = [round(w*r2), round(w*r1);round(w*r2),round(w*r1);round(r3*h),round(w*r4);round(r3*h),round(w*r4)];
%     draw_rect_in_img(img,point,window,1);
end


end

