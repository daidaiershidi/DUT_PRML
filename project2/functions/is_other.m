function [state] = is_other(img, video_w)

N = 6;
[~, c] = find(img == 1);
m = (max(c) + min(c)) / 2;

len = video_w / 6;

state = round(m / len) + 4;


end

