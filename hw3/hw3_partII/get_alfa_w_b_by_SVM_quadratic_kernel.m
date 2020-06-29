function [alfa,b] = get_alfa_w_b_by_SVM_quadratic_kernel(x,z)
% 输入：
% 标签z（NX1）
% 数据x（NXd）每行为一个样本，d维
% 输出：
% w（1XN）
% b（1X1）
% alfa(NX1)用于判断是不是支持向量

% 转变公式形式
len = length(z);
H = (1 + x * x').^2   .*   (z *z');
f = -ones(len, 1);
A = -eye(len);
a = zeros(len, 1);
B = [z.'; zeros(len-1, len)];
b = zeros(len, 1);
% 求解SVM
% [alfa, fval, exitflag, output, lambda] = quadprog(H, f, A, a, B, b,[],[],[])
alfa = quadprog(H, f, A, a, B, b);
% 求解b
% 思路是在边界线两边各取一个支持向量，两者带入函数的结果相差正负号
left_index = -1;
right_index = -1;
for i = 1:len
    if(alfa(i) >= mean(alfa))
        if(z(i) == 1)
            left_index = i;
        end
        if(z(i) == -1)
            right_index = i;
        end
    end
    if(left_index~=-1 && right_index~=-1)
        break
    end
end
b = -0.5*((alfa .* z)' * (1+ x * x(left_index, :)').^2 + (alfa .* z)' * (1+ x * x(right_index, :)').^2);

end

