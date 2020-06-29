function [alfa,w,b] = get_alfa_w_b_by_SVM(x,z)
% 输入：
% 标签z（NX1）
% 数据x（NXd）每行为一个样本，d维
% 输出：
% w（1XN）
% b（1X1）
% alfa(NX1)用于判断是不是支持向量

% 转变公式形式
len = length(z);
H = (x * x') .* (z *z');
f = -ones(len, 1);
A = -eye(len);
a = zeros(len, 1);
B = [z.'; zeros(len-1, len)];
b = zeros(len, 1);
% 求解SVM
alfa = quadprog(H + eye(len) * 0.001, f, A, a, B, b)
w = (alfa .* z)' * x;
j = 0;
for i = 1:len
    if(alfa(i) >= mean(alfa))
        j = i;
        break
    end
end
b = 1 / z(j, :) - x(j, :) * w';


end

