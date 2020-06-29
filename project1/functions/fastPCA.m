function [pcaX, E] = fastPCA(X, k)  
% https://www.ilovematlab.cn/thread-113159-1-1.html
% ����PCA  
% ���룺
% X = [NXd]��ÿ��һ��dά����
% k = ��ά��kά 
% �����
% pcaX = [NXk]  
% E = [dXk]�����ɷ�����  
 
% X_size = size(X);
% X_num = X_size(1);

X = double(X);
% ���ֵ��Z 
mean_X = mean(X);  
Z = double(X) - double(mean_X); 
% ��(X-mean_X)�����
S_t = Z * Z';  
% ���������ǰk������ֵ����������
[E, Langdas] = eigs(S_t, k);  
% Langdas
% �õ�(X-mean_X)���ڻ�����������  
E = Z' * E;  
% ����������һ��  
for i=1:k  
    E(:,i)=E(:,i)/norm(E(:,i));  
end  
% ����pcaX  
pcaX = (Z * E);  

end
 
