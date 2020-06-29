function [pcaX, E] = fastPCA(X, k)  
% 快速PCA  
% 输入：
% X = [NXd]，每行是一个d维样本
% k = 降维到k维 
% 输出：
% pcaA = [kXd]  
% E:主成分向量  

[r c] = size(X);  
% 求均值和Z 
mean_X = mean(X);  
Z = X - repmat(mean_X, r, 1); 
% 求(X-mean_X)的外积
S_t = Z * Z';  
% 计算外积的前k个本征值和本征向量
[E, Langdas] = eigs(S_t, k);  
% 得到(X-mean_X)的内积的特征向量  
E = Z' * E;  
% 特征向量归一化  
for i=1:k  
    E(:,i)=E(:,i)/norm(E(:,i));  
end  
% 计算pcaX  
pcaX = Z * E;  

end
 
