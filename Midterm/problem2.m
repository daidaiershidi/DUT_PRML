%%
% (a)读取全部数据
datas = [];
for label = 1:3
    filename = ['data', num2str(label), '.txt'];
    %fprintf('%s',filename)
    file = load(filename);
    x1 = file(:, 1);
    x2 = file(:, 2);
    label = ones(size(x1)) .* label;
    each_data = [x1, x2, label];
    datas = [datas; each_data];
end
%%
% (a)划分数据集，获得训练和测试数据
each_datas_num = 1000;
train_datas = [];
test_datas = [];
for label = 1:3
    start_num = (label-1) * 2000 + 1;
    each_train_data = datas(start_num:start_num + each_datas_num - 1, :);
    each_test_data = datas(start_num + each_datas_num:start_num + 2000 - 1, :);
    train_datas = [train_datas; each_train_data];
    test_datas = [test_datas; each_test_data];
end
%%
% (a)计算概率p(x)
u = [0, 0];
sigma = [1, 1; 1, 1];
% 计算delta
p_x = [];
for label = 1:3
    start_num = (label-1) * 1000 + 1;
    each_train_data = train_datas(start_num:start_num + each_datas_num - 1, :);
    for i = 1:1000
        p_x_ = parzen_windows_norm(each_train_data(i, 1:2), each_train_data(:, 1:2));
        p_x = [p_x;, p_x_];
    end
end
%%
% (a)画图
for label = 1:3
    start_num = (label-1) * 1000 + 1;
    each_train_data = train_datas(start_num:start_num + each_datas_num - 1, :);
    
    
    %each_p_x = p_x(start_num:start_num + each_datas_num - 1, :);
    %x = each_train_data(:, 1);
    %y = each_train_data(:, 2);
    %z = each_p_x;
    %figure(label);
    %plot3(x, y, z);
    
    
    [X, Y] = meshgrid(-8:0.1:8, -8:0.1:8);
    Z = zeros(length(X), length(X));
    for i = 1:length(X)
        for j = 1:length(X)
            Z(i, j) = parzen_windows_norm([X(i, j), Y(i, j)], each_train_data(:, 1:2));
        end
    end
    figure(label);
    surf(X, Y, Z);
end
%%
% （b）
misclassification = [];
for i = 1:length(test_datas)
    xk = test_datas(i, 1:2);
    xk_label = test_datas(i, 3);
    p = [];
    for label = 1:3
        start_num = (label-1) * each_datas_num + 1;
        p = [p, parzen_windows_norm(xk, train_datas(start_num:start_num + each_datas_num - 1, 1:2))];
    end
    p_x = sum(p);
    p = p ./ p_x;
    [maxVal, maxInd] = max(p); % MAP
    if maxInd ~= xk_label
        misclassification = [misclassification; 1];
    else
        misclassification = [misclassification; 0];
    end
end
for label = 1:3
    start_num = (label-1) * each_datas_num + 1;
    each_misclassification = misclassification(start_num:start_num + each_datas_num - 1, :);
    fprintf('%f ', sum(each_misclassification) / 1000);
end
%%
% (c)
misclassification = [];
for i = 1:length(test_datas)
    xk = test_datas(i, 1:2);
    xk_label = test_datas(i, 3);
    knn_label = KNN(train_datas, xk, 1);
    if knn_label ~= xk_label
        misclassification = [misclassification; 1];
    else
        misclassification = [misclassification; 0];
    end
end
for label = 1:3
    start_num = (label-1) * each_datas_num + 1;
    each_misclassification = misclassification(start_num:start_num + each_datas_num - 1, :);
    fprintf('%f ', sum(each_misclassification) / 1000);
end
%%
% (d)
misclassification = [];
for i = 1:length(test_datas)
    xk = test_datas(i, 1:2);
    xk_label = test_datas(i, 3);
    knn_label = KNN(train_datas, xk, 10);
    if knn_label ~= xk_label
        misclassification = [misclassification; 1];
    else
        misclassification = [misclassification; 0];
    end
end
for label = 1:3
    start_num = (label-1) * each_datas_num + 1;
    each_misclassification = misclassification(start_num:start_num + each_datas_num - 1, :);
    fprintf('%f ', sum(each_misclassification) / 1000);
end
