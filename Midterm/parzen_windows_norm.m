function [p] = parzen_windows_norm(xk, each_data)
% ����parzen����������Ϊ��̬�ֲ�
% ���룺
% ��������xk:��1X2��
% ͬ�����ݼ�each_data:��NX2����NΪ��������
% �����
% xk����each_data�����ݵĸ���

u = [0, 0];
sigma = [1, 0; 0, 1];
% �������
delta = 0;
for j = 1:length(each_data)
    x = xk -  each_data(j, :);
    delta_ = (1/(2*pi*sqrt(det(sigma)))).*exp( -0.5.*( (x-u)*inv(sigma)*(x-u)' ) ); 
    delta = delta + delta_;
end
p = delta ./ length(each_data);

end

