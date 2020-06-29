%%
addpath .\201783107_HW1
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(a)(a)(a)(a)(a)(a)(a)(a)(a)(a)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% ��ȡȫ������
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
% ��ͼ
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


% ���ѵ���Ͳ������ݣ��ڽ���PCA��FLD֮ǰҪ����
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
% ѵ�����ݽ���PCA
X = train_datas(:, 1:2);
E_ = PCA(X, 1)
Y = X * E_;

% ��ͼ
markers = ['o', 'x', '*'];
color = ['r', 'b', 'k'];
for label = 1:3
    start_num = (label-1) * 1000 + 1;
    plot_num = 1000;
    x1 = Y(start_num:start_num + plot_num - 1);
    x2 = ones(size(x1));
    if strcmp(markers(label), 'o')  % ���м俴�����������Խ�size��Ϊ40�������
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
% ѵ�����ݽ���PCA
X = train_datas(:, 1:2);
E_ = PCA(X, 1);
Y = X * E_;
% PCA���ѵ�����ݼӱ�ǩ
train_datas_after_PCA = [Y, train_datas(:, 3)];
% �������ݽ���PCA
test_X = test_datas(:, 1:2);
test_E_ = PCA(test_X, 1);
test_Y = test_X * test_E_;
% KNN���ಢͳ�ƴ������
misclassify = [];
for k = 15:1:25  % k��15��25
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
% ѵ�����ݽ���FLD
X = train_datas(:, 1:2);
W = FLD(X, 3, 1);
Y = X * W;

% ��ͼ
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
% ѵ�����ݽ���FLD
X = train_datas(:, 1:2);
W = FLD(X, 3, 1);
Y = X * W;
% FLD���ѵ���ӱ�ǩ
train_datas_after_FLD = [Y, train_datas(:, 3)];
% �������ݽ���PCA
test_X = test_datas(:, 1:2);
test_W = FLD(test_X, 3, 1);
test_Y = test_X * test_W;
% KNN���ಢͳ�ƴ������
misclassify = [];
for k = 5:1:15 % k��5��15
    errs = []; % ���ÿһ��������misclassification rate
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