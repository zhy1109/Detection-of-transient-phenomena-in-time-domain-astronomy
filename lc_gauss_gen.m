function y=lc_gauss_gen(t,A1,u1,sig1,A2,u2,sig2,T,tao,sig,sig_A)
%%%% t�������ʱ���� A1:��˹1�ķ�ֵ  u1:��˹1������λ��  sig1����˹1�ķ�Χ 
%%%% A2:��˹2�ķ�ֵ  u2:��˹2������λ��  sig2����˹2�ķ�Χ  T:����  tao:�����񵴷���ϵ�� tao*T
%%%% T_os:�񵴵����ڷ��� Cs:�����źŵķ�ֵ  CA:���������ľ�ֵ

%CA=0;
%CA=0;
%%%%test1:   A1:  u1:  sig1:
len=max(size(t));
a=1;
T_os=tao*T*randn(1,1);
Cs=100+sig_A*rand(1,1);
% if Cs<0
%     Cs=0
% end
for i=1:len
%     seed_cir=floor(t(i)/T);
%     randn('seed',seed_cir)
%    T_os=tao*T*randn(1,1);

     seed_cir=floor(t(i)/T);
     if seed_cir>a
        a=a+1;
        T_os=tao*T*randn(1,1);%���ڶ���
        Cs=100+sig_A*rand(1,1);
%         if Cs<0
%             Cs=0
%         end
    end
    
    %Cs=1+0.5*randn(1,1);
    norm_t=(rem(t(i),T)+rem(T_os,T))/(T);
    if norm_t<0
        norm_t=norm_t+1;
    end
    y(i)=Cs*(A1/sqrt(2*pi*(sig1^2))*exp(-(norm_t-u1)^2/(2*(sig1^2)))+A2/sqrt(2*pi*(sig2^2))*exp(-(norm_t-u2)^2/(2*(sig2^2)))); 
%   y(i)=A2/sqrt(2*pi*(sig2^2))*exp(-(norm_t-u2)^2/(2*(sig2^2)));
%    y(i)=Cs*(A1/sqrt(2*pi*(sig1^2))*exp(-(norm_t-u1)^2/(2*(sig1^2)))); 
   %y(i)=0;     
end
y=y+(sig*randn(1,len));