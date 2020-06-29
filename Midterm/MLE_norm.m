function [u, sigma] = MLE_norm(each_data)
% ͬһ�����ݼ���2ά��̬�ֲ��������Ȼ����
% ���룺
% each_data��ͬһ�����ݼ��� shape:(NX2)(N������������2��ά��)
% �����
% ���Ƴ��Ĳ���


% �������u��sigma
u = mean(each_data);
sigma = zeros(length(u), length(u));
for i = 1:length(each_data)
    xk = each_data(i, :);
    sigma = sigma + ((xk-u)' * (xk-u));
end
sigma = sigma ./ length(each_data);


end

