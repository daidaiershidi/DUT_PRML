%%
% (a)
% 构建数据
x = [1, 6; 1, 10; 4, 11; 5, 2; 7, 6; 10, 4;];
z = [1; 1; 1; -1; -1; -1];
% 转变公式形式
H = (x * x') .* (z *z');
f = -ones(6, 1);
A = -eye(6);
a = zeros(6, 1);
B = [z.'; zeros(5, 6)];
b = zeros(6, 1);
% 求解SVM
alfa = quadprog(H + eye(6) * 0.001, f, A, a, B, b);
w = (alfa .* z)' * x;
b = 1 / z(1, :) - x(1, :) * w';
% 求解超平面函数y = m * x + b
k = -w(1)/w(2);
b = -(b/w(2));
x_1 = 0:0.1:12;
x_2 = k * x_1 + b;
% 画图
for i = 1:length(x)
    if(z(i) == 1)
        c = 'r';
    else
        c = 'b';
    end
    if(alfa(i) > mean(alfa))
        size = 50;
        x0 = x(i, 1);
        y0 = x(i, 2);
        x1 = (k*y0+x0-k*b)/(1+k*k); % 求投影
        y1 = k*x1+b;
        [x0,y0,x1,y1]
        plot([x0, x1], [y0,y1])
        axis equal
        % quiver(x0,y0,0x2,y2)
        hold on
    else
        size = 10;
    end    
    scatter(x(i, 1), x(i, 2), size, c, 'filled')
    hold on
end
plot(x_1, x_2)
axis equal
%%
% (b)
% 读取数据
datas = [];
for label = 1:2
    filename = ['TrainSet', num2str(label), '.txt'];
    file = load(filename);
    datas = [datas; file];
    fprintf('%s:%d\n',filename, length(file))
end
%%
% (b)
% 计算SVM
x = datas(1:40, 1:2);
z = datas(1:40, 3);
[alfa, w, b] = get_alfa_w_b_by_SVM(x, z);
[w, b]
% 求解超平面函数y = m * x + b_
k = -w(1)/w(2);
b_ = -(b/w(2));
x_1 = min(x(:, 1)):0.1:max(x(:, 1));
x_2 = k * x_1 + b_;
%%
% (b)
% 画图
for i = 1:length(x)
    if(z(i) == 1)
        c = 'r';
    else
        c = 'b';
    end
    if(alfa(i) > mean(alfa))
        size = 50;
        x0 = x(i, 1);
        y0 = x(i, 2);
        x1 = (k*y0+x0-k*b_)/(1+k*k); % 求投影
        y1 = k*x1+b_;
        plot([x0, x1], [y0,y1])
        axis equal
        % quiver(x0,y0,0x2,y2)
        hold on
    else
        size = 10;
    end    
    scatter(x(i, 1), x(i, 2), size, c, 'filled')
    hold on
end
plot(x_1, x_2)
axis equal
%%
% (c)
% 计算SVM
x = datas(41:80, 1:2); 
z = datas(41:80, 3);
[alfa, b] = get_alfa_w_b_by_SVM_quadratic_kernel(x, z);
[b]
%%
% （c）
% 画散点图
for i = 1:length(x)
    if(z(i) == 1)
        c = 'r';
    else
        c = 'b';
    end
    if(alfa(i) > mean(alfa))
        size = 50;
    else
        size = 10;
    end    
    scatter(x(i, 1), x(i, 2), size, c, 'filled')
    hold on
end
axis equal
% 画分界线
A = (alfa .* z)' * x(:, 1).^2;
B = (alfa .* z)' * x(:, 2).^2;
C = (2 .* alfa .* z)' * (x(:, 1) .* x(:, 2));
D = (2 .* alfa .* z)' * x(:, 1);
E = (2 .* alfa .* z)' * x(:, 2);
F = alfa' * z;
p = [A, B, C, D, E, b+F]
syms x1 x2
conic = p(1)*x1^2+p(2)*x2^2+p(3)*x1*x2+p(4)*x1+p(5)*x2+p(6);
c = ezplot(conic,[-100,100],[-100,100]);
hold on