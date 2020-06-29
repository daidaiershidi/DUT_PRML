function [Dist,D,k,w]=DTW(vector1,vector2)

 
[row,M]=size(vector1); 
if (row > M) 
    M=row; 
    vector1=vector1'; 
end
[row,N]=size(vector2); 
if (row > N) 
    N=row; 
    vector2=vector2'; 
end
d=sqrt((repmat(vector1',1,N)-repmat(vector2,M,1)).^2);
d
D=zeros(size(d));
D(1,1)=d(1,1);
 
for m=2:M
    D(m,1)=d(m,1)+D(m-1,1); %���㴹ֱ�����Ӧ��ľ��룬����ֵ���ϲ���
end
for n=2:N
    D(1,n)=d(1,n)+D(1,n-1); %����ˮƽ�����϶�Ӧ��ľ��룬����ֵ���ϲ���
end
for m=2:M   %����Խ����ϵĶ�Ӧ��ľ��룬��ʱӦ��������3�����С�������
    for n=2:N
        D(m,n)=d(m,n)+min(D(m-1,n),min(D(m-1,n-1),D(m,n-1))); % this double MIn construction improves in 10-fold the Speed-up. Thanks Sven Mensing
    end
end
D
 % D��������ۼӾ���D
Dist=D(M,N);  
n=N;
m=M;
k=1;
w=[M N]; 
while ((n+m)~=2)
    if (n-1)==0
        m=m-1;
    elseif (m-1)==0
        n=n-1;
    else 
      [values,number]=min([D(m-1,n),D(m,n-1),D(m-1,n-1)]);
      switch number 
      case 1
        m=m-1;
      case 2
        n=n-1;
      case 3
        m=m-1;
        n=n-1;
      end
  end
    k=k+1;
    w=[m n; w]; 
end
    
end

