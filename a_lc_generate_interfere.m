clear all 
close all
%fs=1000;
% y=load('matlab_data\1-2.txt');
% length=max(size(y));
% t=(0:1:length-1)/fs;  %时间
%T=0.03365452386;
%sig=0.4./(10.^(snr./20)) 求取高斯噪声标准差的公式
%snr:20 10 0 -10 -20 (0.04 0.1265    0.4000  1.2649    4.0000 )
%这里0.4是A1=0.1;A2=0.13;u1=0.35;u2=0.6;sig1=0.03;sig2=0.04;的标准差
fs=200;
t0=1/fs*(0:1:20000);
length=max(size(t0));
t_fold=(0:1:length-1)/fs;  %时间
%t_fold=1/fs*(0:1:6001);
A1=0.01;
A2=0.01;
u1=0.35;
u2=0.04;
sig1=0.1;
sig2=0.04;
tao=1;              %%周期振荡系数
sig= 0.0;          %%高斯噪声的标准差
sig_A=50;          %%辐射幅度波动的标准差
%%%% t：输入的时间间隔 A1:高斯1的幅值  u1:高斯1的中心位置  sig1：高斯1的范围 
%%%% A2:高斯2的幅值  u2:高斯2的中心位置  sig2：高斯2的范围  T:周期  tao:周期振荡幅度系数 tao*T
%%%% T_os:振荡的周期幅度 Cs:轮廓信号的幅值  CA:加性噪声的均值
T0=0.4672897;
y1=lc_gauss_gen(t0,A1,u1,sig1,A2,u2,sig2,T0,tao,sig,sig_A);   %光变曲线%fc:35.02Hz
% y1=y1*0.1;
[~,m]=find(y1<0);
y1(m)=0;
fft1=abs(fft(y1-mean(y1)));
f=fs/2*linspace(0,1,max(size(fft1))/2);
figure
plot(f,fft1(1:(max(size(fft1)-1)/2)),'LineWidth',1)
xlabel('Frequency(Hz)');
ylabel('FFT Power');
set(gca,'FontName','Times New Roman','FontSize',20,'FontWeight','bold')
figure
plot(y1)
%%转换为toa
numbers=5*max(t0)/T0;%产生的总光子数
curl = 1;%起始点
TOAs = 1;
y1=y1/(sum(y1)/5);
%%%产生光子数的点 1000 bins数
for i=1:numbers-1
    E=exprnd(1);%不能动
    steps = generate_nextTOA(y1, curl, E);%产生下一个
    TOAs(i+1) = TOAs(i)+steps;
    curl = mod(curl+steps,1000);
    if curl==0
        curl = 1000;
    end
end
% 将TOAs转换成光变曲线
len = max(size(TOAs));
lc = zeros(TOAs(len),1);
for i=1:len
    lc(TOAs(i))=1;
end
% int=1000;
%  Nf=max(size(lc));
% f=(1:1:Nf)/fs;
%  profile=epoch_folding_higeff(f,lc,T0,int);
% figure
% plot(profile)
fft2=abs(fft((lc-mean(lc))));
f=fs/2*linspace(0,1,max(size(fft2))/2);
figure
plot(f,fft2(1:floor((max(size(fft2))/2))),'LineWidth',1)
xlabel('Frequency(Hz)');
ylabel('FFT Power');
set(gca,'FontName','Times New Roman','FontSize',20,'FontWeight','bold')
hold on
%%描点连线
% x=[0.8401,2.1402,4.2804];
xx=0:0.01:8.3;
% {[,];[,];[,];[,];[5,];[,];[,138.194619223668];[2.19998010900446,185.417384932488];[0.434721757823979,63.8812490888503]}
x=[2.2,9.68,8.3 ,6.4,5,3.2,2.599,1.8,0.2,1.19,0.799,0.4,4.199];
y=[510,104,110.6,121.6,158.8,161.84,185.39,463.5,348.4,169.2,342.72,383.09,369.3];
yy=spline(x,y,xx);
plot(xx,yy,'LineWidth',1.5,'Color','r');
hold on
plot(x,y,'*','Color','k')
hold off
% figure
% plot(abs(fft((lc))))