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
% (a)画图
markers = ['o', 'x', '*'];
color = ['r', 'b', 'k'];
for label = 1:3
    start_num = (label-1) * 2000 + 1;
    plot_num = 1000;
    x1 = datas(:, 1);
    x2 = datas(:, 2);
    x1 = x1(start_num:start_num + plot_num - 1);
    x2 = x2(start_num:start_num + plot_num - 1);
    if strcmp(markers(label), 'o')
        scatter(x1, x2, 20, color(label), 'filled', markers(label));
        hold on
    else
        scatter(x1, x2, 20, color(label), markers(label));
        hold on
    end
end
xlabel('x1');
ylabel('x2');
legend('class1', 'class2', 'class3')
hold off
%%
% (b)划分数据集，获得训练和测试数据
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
% (b)mle计算均值u和cov，并计算P(X|Wi)
P_x_w = [];
u = [];
sigma = [];
for label = 1:3
    start_num = (label-1) * 1000 + 1;
    each_train_data = train_datas(start_num:start_num + each_datas_num - 1, :);
    [u_, sigma_]  = MLE_norm(each_train_data(:, 1:2));
    for i = 1:each_datas_num
        xk = each_train_data(i, 1:2);
        exch_P_x_w_ = normal_distribution(xk, u_, sigma_);
        P_x_w = [P_x_w; exch_P_x_w_];
    end
    u = [u; u_];
    sigma = [sigma; sigma_];
end
u, sigma
%%
% (b)画图
for label = 1:3
    %start_num = (label-1) * 1000 + 1;
    %each_train_data = train_datas(start_num:start_num + each_datas_num - 1, :);
    %each_P_x_w = P_x_w(start_num:start_num + each_datas_num - 1, :);
    %x = each_train_data(:, 1);
    %y = each_train_data(:, 2);
    %z = each_P_x_w;
    %figure(label);
    %plot3(x, y, z);
    
    
    u_ = u(label, :);
    sigma_ = sigma((label-1) * 2 + 1:2 * label, :);
    [X, Y] = meshgrid(-15:0.1:15, -15:0.1:15);
    Z = zeros(length(X), length(X));
    for i = 1:length(X)
        for j = 1:length(X)
            Z(i, j) = normal_distribution([X(i, j), Y(i, j)], u_, sigma_);
        end
    end
    figure(label);
    surf(X, Y, Z);
end
%%
% (c)
misclassification = [];
for label = 1:3
    each_misclassification = 0;
    start_num = (label-1) * 1000 + 1;
    each_train_data = test_datas(start_num:start_num + each_datas_num - 1, :);
    for i = 1:each_datas_num
        xk = each_train_data(i, 1:2);
        xk_label = each_train_data(i, 3);
        p_x_w = [];
        for j = 1:3
            each_u = u(j, :);
            each_sigma = sigma((j-1) * length(each_u) + 1:j * length(each_u), :);
            each_p_x_w = normal_distribution(xk, each_u, each_sigma);
            p_x_w = [p_x_w, each_p_x_w];
        end
        p_x_w_X_p_w = p_x_w .* 1/3; % 中间的X表示乘
        p_x = sum(p_x_w_X_p_w);
        p_w_x = p_x_w_X_p_w ./ p_x;
        [maxVal, maxInd] = max(p_w_x); % MAP
        if maxInd ~= xk_label
            each_misclassification = each_misclassification + 1;
        end
    end
    misclassification = [misclassification, each_misclassification / each_datas_num];
end
misclassification
%%
% （d）1.重新划分数据集
each_datas_num = 500;
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
% （d）2.mle计算均值u和cov，并计算P(X|Wi)
P_x_w = [];
u = [];
sigma = [];
for label = 1:3
    start_num = (label-1) * each_datas_num + 1;
    each_train_data = train_datas(start_num:start_num + each_datas_num - 1, :);
    [u_, sigma_]  = MLE_norm(each_train_data(:, 1:2));
    for i = 1:each_datas_num
        xk = each_train_data(i, 1:2);
        exch_P_x_w_ = normal_distribution(xk, u_, sigma_);
        P_x_w = [P_x_w; exch_P_x_w_];
    end
    u = [u; u_];
    sigma = [sigma; sigma_];
end
u, sigma
%%
% （d）3.画图
for label = 1:3
    %start_num = (label-1) * each_datas_num + 1;
    %each_train_data = train_datas(start_num:start_num + each_datas_num - 1, :);
    %each_P_x_w = P_x_w(start_num:start_num + each_datas_num - 1, :);
    %figure(label);
    %plot3(each_train_data(:, 1), each_train_data(:, 2), each_P_x_w);
    
    
    u_ = u(label, :);
    sigma_ = sigma((label-1) * 2 + 1:2 * label, :);
    [X, Y] = meshgrid(-15:0.1:15, -15:0.1:15);
    Z = zeros(length(X), length(X));
    for i = 1:length(X)
        for j = 1:length(X)
            Z(i, j) = normal_distribution([X(i, j), Y(i, j)], u_, sigma_);
        end
    end
    figure(label);
    surf(X, Y, Z);
end
%%
% （d）4.计算误分类率
misclassification = [];
for label = 1:3
    each_misclassification = 0;
    start_num = (label-1) * 1500 + 1;
    each_train_data = test_datas(start_num:start_num + 1500 - 1, :);
    for i = 1:1500
        xk = each_train_data(i, 1:2);
        xk_label = each_train_data(i, 3);
        p_x_w = [];
        for j = 1:3
            each_u = u(j, :);
            each_sigma = sigma((j-1) * length(each_u) + 1:j * length(each_u), :);
            each_p_x_w = normal_distribution(xk, each_u, each_sigma);
            p_x_w = [p_x_w, each_p_x_w];
        end
        p_x_w_X_p_w = p_x_w .* 1/3; % 中间的X表示乘
        p_x = sum(p_x_w_X_p_w);
        p_w_x = p_x_w_X_p_w ./ p_x;
        [maxVal, maxInd] = max(p_w_x); % MAP
        if maxInd ~= xk_label
            each_misclassification = each_misclassification + 1;
        end
    end
    misclassification = [misclassification, each_misclassification / each_datas_num];
end
misclassification