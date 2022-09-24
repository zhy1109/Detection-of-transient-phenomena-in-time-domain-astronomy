function y=lc_gauss_gen(t,A1,u1,sig1,A2,u2,sig2,T,tao,sig,sig_A)
%%%% t：输入的时间间隔 A1:高斯1的幅值  u1:高斯1的中心位置  sig1：高斯1的范围 
%%%% A2:高斯2的幅值  u2:高斯2的中心位置  sig2：高斯2的范围  T:周期  tao:周期振荡幅度系数 tao*T
%%%% T_os:振荡的周期幅度 Cs:轮廓信号的幅值  CA:加性噪声的均值

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
        T_os=tao*T*randn(1,1);%周期抖动
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