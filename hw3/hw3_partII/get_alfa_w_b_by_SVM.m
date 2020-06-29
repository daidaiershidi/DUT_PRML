function [alfa,w,b] = get_alfa_w_b_by_SVM(x,z)
% ���룺
% ��ǩz��NX1��
% ����x��NXd��ÿ��Ϊһ��������dά
% �����
% w��1XN��
% b��1X1��
% alfa(NX1)�����ж��ǲ���֧������

% ת�乫ʽ��ʽ
len = length(z);
H = (x * x') .* (z *z');
f = -ones(len, 1);
A = -eye(len);
a = zeros(len, 1);
B = [z.'; zeros(len-1, len)];
b = zeros(len, 1);
% ���SVM
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

