function [pcaX, E] = fastPCA(X, k)  
% https://www.ilovematlab.cn/thread-113159-1-1.html
% 快速PCA  
% 输入：
% X = [NXd]，每行一个d维样本
% k = 降维到k维 
% 输出：
% pcaX = [NXk]  
% E = [dXk]，主成分向量  
 
% X_size = size(X);
% X_num = X_size(1);

X = double(X);
% 求均值和Z 
mean_X = mean(X);  
Z = double(X) - double(mean_X); 
% 求(X-mean_X)的外积
S_t = Z * Z';  
% 计算外积的前k个特征值和特征向量
[E, Langdas] = eigs(S_t, k);  
% Langdas
% 得到(X-mean_X)的内积的特征向量  
E = Z' * E;  
% 特征向量归一化  
for i=1:k  
    E(:,i)=E(:,i)/norm(E(:,i));  
end  
% 计算pcaX  
pcaX = (Z * E);  

end
 
