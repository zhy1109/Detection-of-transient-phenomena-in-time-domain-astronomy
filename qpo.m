function y1=qpo(tao,sig_A,size)
fs=10;
t0=1/fs*(0:1:size);
%t_fold=1/fs*(0:1:6001);
A1=0.01;
A2=0.01;
u1=0.35;
u2=0.04;
sig1=0.1;
sig2=0.04;
% tao=1;              %%周期振荡系数
sig= 0.0;          %%高斯噪声的标准差
% sig_A=50;          %%辐射幅度波动的标准差
%%%% t：输入的时间间隔 A1:高斯1的幅值  u1:高斯1的中心位置  sig1：高斯1的范围 
%%%% A2:高斯2的幅值  u2:高斯2的中心位置  sig2：高斯2的范围  T:周期  tao:周期振荡幅度系数 tao*T
%%%% T_os:振荡的周期幅度 Cs:轮廓信号的幅值  CA:加性噪声的均值
T0=0.4672897;
y1=lc_gauss_gen(t0,A1,u1,sig1,A2,u2,sig2,T0,tao,sig,sig_A);   %光变曲线%fc:35.02Hz
end