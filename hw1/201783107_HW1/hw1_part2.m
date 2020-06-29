%%
addpath .\201783107_HW1
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(a)(a)(a)(a)(a)(a)(a)(a)(a)(a)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 读取全部数据
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
% 画图
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


% 获得训练和测试数据，在进行PCA和FLD之前要运行
train_datas = [];
test_datas = [];
for label = 1:3
    start_num = (label-1) * 2000 + 1;
    train_datas_num = 1000;
    each_tarin_data = datas(start_num:start_num + train_datas_num - 1, :);
    each_test_data = datas(start_num + train_datas_num:start_num + 2000 - 1, :);
    train_datas = [train_datas; each_tarin_data];
    test_datas = [test_datas; each_test_data];
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PCA(b)PCA(b)PCA(b)PCA(b)PCA(b)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 训练数据进行PCA
X = train_datas(:, 1:2);
E_ = PCA(X, 1)
Y = X * E_;

% 画图
markers = ['o', 'x', '*'];
color = ['r', 'b', 'k'];
for label = 1:3
    start_num = (label-1) * 1000 + 1;
    plot_num = 1000;
    x1 = Y(start_num:start_num + plot_num - 1);
    x2 = ones(size(x1));
    if strcmp(markers(label), 'o')  % 在中间看不出来，所以讲size改为40并内填充
        scatter(x1, x2, 40, color(label), 'filled', markers(label));
        hold on
    else
        scatter(x1, x2, 20, color(label), markers(label));
        hold on
    end
    hold on
end
hold off

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PCA(c)PCA(c)PCA(c)PCA(c)PCA(c)PCA(c)PCA(c)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 训练数据进行PCA
X = train_datas(:, 1:2);
E_ = PCA(X, 1);
Y = X * E_;
% PCA后的训练数据加标签
train_datas_after_PCA = [Y, train_datas(:, 3)];
% 测试数据进行PCA
test_X = test_datas(:, 1:2);
test_E_ = PCA(test_X, 1);
test_Y = test_X * test_E_;
% KNN分类并统计错误次数
misclassify = [];
for k = 15:1:25  % k从15到25
    errs = [];
    for j = 1:3
        err_num = 0;
        start_num = (j-1) * 1000 + 1;
        for i = start_num:start_num + 1000 - 1
            label = KNN(train_datas_after_PCA, test_Y(i, :), k);
            if label ~= test_datas(i, 3)
               err_num = err_num + 1;
        %        fprintf('%d: %f!=%f\n', i, label, test_datas(i, 3))
            end
        end
        errs = [errs, err_num / 1000];
    end
    misclassify = [misclassify; errs];
end
xlswrite('PCA.xlsx', misclassify)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%FLD(b)FLD(b)FLD(b)FLD(b)FLD(b)FLD(b)FLD(b)FLD(b)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 训练数据进行FLD
X = train_datas(:, 1:2);
W = FLD(X, 3, 1);
Y = X * W;

% 画图
markers = ['o', 'x', '*'];
color = ['r', 'b', 'k'];
for label = 1:3
    start_num = (label-1) * 1000 + 1;
    plot_num = 1000;
    x1 = Y(start_num:start_num + plot_num - 1);
    x2 = ones(size(x1));
    scatter(x1, x2, 20, color(label), markers(label));
    hold on
end
hold off

%%
%%%%%%%%%%%%%%%%%%%%%%%%FLD(c)FLD(c)FLD(c)FLD(c)FLD(c)FLD(c)FLD(c)FLD(c)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 训练数据进行FLD
X = train_datas(:, 1:2);
W = FLD(X, 3, 1);
Y = X * W;
% FLD后的训练加标签
train_datas_after_FLD = [Y, train_datas(:, 3)];
% 测试数据进行PCA
test_X = test_datas(:, 1:2);
test_W = FLD(test_X, 3, 1);
test_Y = test_X * test_W;
% KNN分类并统计错误次数
misclassify = [];
for k = 5:1:15 % k从5到15
    errs = []; % 存放每一类样本的misclassification rate
    for j = 1:3
        err_num = 0;
        start_num = (j-1) * 1000 + 1;
        for i = start_num:start_num + 1000 - 1
            label = KNN(train_datas_after_FLD, test_Y(i, :), k);
            if label ~= test_datas(i, 3)
               err_num = err_num + 1;
        %        fprintf('%d: %f!=%f\n', i, label, test_datas(i, 3))
            end
        end
        errs = [errs, err_num / 1000];
    end
    misclassify = [misclassify; errs];
end
xlswrite('FLD.xlsx', misclassify)