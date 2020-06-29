function [Y] = LLE(X,K,d)
X = double(X);
[D,N] = size(X);
% Step1: 求近邻
% fprintf(1,'-->Finding %d nearest neighbours.\n',K);
X2 = sum(X.^2,1);
distance = repmat(X2,N,1)+repmat(X2',1,N)-2*X'*X;
[sorted,index] = sort(distance);
neighborhood = index(2:(1+K),:);
 
%Step2: 解重构权W
% if(K>D)
%   fprintf(1,'   [注意:K > D;将使用正则化]\n');
%   tol=1e-3; % regularlizer in case constrained fits are ill conditioned在条件受限的情况下使用调节器
% else
%   tol=0;
% end
 
W = zeros(N,N);
for ii=1:N
    C = zeros(K,K);
    for jj=1:K
        jjj=neighborhood(jj,ii);
        z =(X(:,ii)-X(:,jjj)); % shift ith pt to origin
        for jj1=1:K
            jjj1=neighborhood(jj1,ii);
            z1=(X(:,ii)-X(:,jjj1));
            C(jj,jj1) = z'*z1;     %Cjk                                   % local covariance
%            C(jj,jj1)=C(jj,jj1)\1; % solve Cw=1
            % regularlization (K>D)
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%
%    C1 = C1 + eye(K,K)*tol*trace(C1); 
C=C\ones(K,1);
    for  jj=1:K
         jjj=neighborhood(jj,ii);
         W(ii,jjj) = sum(C(jj,:))/sum(C(:)); 
    end
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: 求M矩阵 M=(I-W)'(I-W)
I = eye(N);
M=(I-W)'*(I-W);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculation of embedding
%[V,D] = eig(A) 返回特征值的对角矩阵 D 和矩阵 V，其列是对应的右特征向量，使得 A*V = V*D
%求特征值特征向量,找到K个最小特征值对应的特征向量
[V,D]=eig(M);
tz=diag(D);
% tzp=sort(tz);
Y=V(:,1:d);