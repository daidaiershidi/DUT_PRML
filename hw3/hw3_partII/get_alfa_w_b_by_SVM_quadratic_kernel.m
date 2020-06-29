function [alfa,b] = get_alfa_w_b_by_SVM_quadratic_kernel(x,z)
% ���룺
% ��ǩz��NX1��
% ����x��NXd��ÿ��Ϊһ��������dά
% �����
% w��1XN��
% b��1X1��
% alfa(NX1)�����ж��ǲ���֧������

% ת�乫ʽ��ʽ
len = length(z);
H = (1 + x * x').^2   .*   (z *z');
f = -ones(len, 1);
A = -eye(len);
a = zeros(len, 1);
B = [z.'; zeros(len-1, len)];
b = zeros(len, 1);
% ���SVM
% [alfa, fval, exitflag, output, lambda] = quadprog(H, f, A, a, B, b,[],[],[])
alfa = quadprog(H, f, A, a, B, b);
% ���b
% ˼·���ڱ߽������߸�ȡһ��֧�����������ߴ��뺯���Ľ�����������
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

