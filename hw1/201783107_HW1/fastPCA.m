function [pcaX, E] = fastPCA(X, k)  
% ����PCA  
% ���룺
% X = [NXd]��ÿ����һ��dά����
% k = ��ά��kά 
% �����
% pcaA = [kXd]  
% E:���ɷ�����  

[r c] = size(X);  
% ���ֵ��Z 
mean_X = mean(X);  
Z = X - repmat(mean_X, r, 1); 
% ��(X-mean_X)�����
S_t = Z * Z';  
% ���������ǰk������ֵ�ͱ�������
[E, Langdas] = eigs(S_t, k);  
% �õ�(X-mean_X)���ڻ�����������  
E = Z' * E;  
% ����������һ��  
for i=1:k  
    E(:,i)=E(:,i)/norm(E(:,i));  
end  
% ����pcaX  
pcaX = Z * E;  

end
 
