function [p] = normal_distribution(xk, u, sigma)
% ����2ά��̬�ֲ������ܶ�
% ���룺
% xk:2ά����(1X2)
% u:��ֵ
% sigma:Э����
% �����
% ��̬�����ܶ�

p = (1/(2*pi*sqrt(det(sigma))))*exp(-0.5.*( (xk-u)*inv(sigma)*(xk-u)' ));

end

