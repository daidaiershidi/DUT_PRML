%%
addpath .\functions;
%%
data = load('k_means_test_data.txt');
k_color = ['r', 'g', 'b'];
[data_label,k_points] = k_means(data,3,0.0001);
for i = 1:3
    point = k_points(i,:);
    scatter(point(1), point(2), '*', k_color(i))
    hold on
end
for i = 1:length(data_label)
    c = k_color(data_label(i,:));
    point = data(i,:);
    scatter(point(1), point(2), c)
    hold on
end

