%这是用泊松分布模拟TOAs的程序,附属m函数文件,generate_nextTOA.m,lc_gauss_gen.m
clear all
close all
% 生成轮廓信号，光子数总和50，长度1000
fs=1000;%采样频率
Ts=1/fs;%采样周期
% N0=4000;%采样点数
% t0=(1:1000)*Ts;%时间序列
T=1/2.141124;
t0=(1:T*1000)*Ts;%时间序列
A1=0.2;
A2=0.2;
u1=0.33;
u2=0.75;
sig1=0.075;
sig2=0.075;
tao=0;              %%周期振荡系数
sig= 0;          %%高斯噪声的标准差
sig_A=0;          %%辐射幅度波动的标准差
%T=0.010414494596313;
%T =  0.06568;
y1=lc_gauss_gen(t0,A1,u1,sig1,A2,u2,sig2,T,tao,sig,sig_A);   %光变曲线%fc:35.02Hz
y1 = y1/(sum(y1)/50);
%y1 = y1;
% 展示轮廓信号
% figure;plot(y1)
% 生成轮廓信号，采样频率1000Hz，周期1s，一个周期内50个光子。
numbers=50*max(t0)/T;%产生的总光子数
% period_resolution = 0.001;
%0.04 0.033s
%4 1s
diff=0;
curl = 1;
TOAs = 1;
for i=1:numbers-1
    E=exprnd(1);
    steps = generate_nextTOA(y1, curl, E);
    TOAs(i+1) = TOAs(i)+steps;
    curl = mod(curl+steps,1000);
    if curl==0;
        curl = 1000;
    end
end

% 将TOAs转换成光变曲线
len = max(size(TOAs));
lc = zeros(TOAs(len),1);
for i=1:len
    lc(TOAs(i))=1;
end
%%加噪声
  nn=rand(max(size(lc)),1)>0.98;
  nn=0;
     lc=lc+nn;
%%对光变曲线进行历元折叠
y=lc;
 int=1024;
 N=max(size(lc));
 t=(0:N-1)*(Ts/10);
profile_stand=epoch_folding_higeff(t,lc,T,int);
figure
plot(profile_stand)
% sig=y(1:N)';
sig=y';

%归一化
sig=(sig-mean(sig));

N2=length(sig);
NY=2^nextpow2(N2);
[ACF,lags,bounds] = autocorr(sig,N2-1);
%subplot(2,1,2);plot(ACF(1:34))
%ACF(1)=ACF(2);
%ACF=(ACF-mean(ACF))/std(ACF,1);
Nf=len;
f=((0:Nf-1)/2/Nf)'*fs;
% stt = T+period_resolution*(-149:1:149);

%%%%历元折叠%%%%%%%

%  profile=zeros(299,int);
%  profile2=zeros(299,int);
%  for i=1:max(size(stt))
%      profile(i,:)=epoch_folding_higeff(t0,ACF,stt(i),int);
%      profile2(i,:)=epoch_folding_higeff(t0,sig,stt(i),int);
%  end
%  profile=profile/max(max(profile));
%  profile2=profile2/max(max(profile2));
%   figure;imagesc(profile)
% figure;imagesc(1:int,f,profile2)

a=epoch_folding_higeff(t,sig,T,int);
b=epoch_folding_higeff(t,ACF,T,int);
a=a/max(max(a));
b=b/max(max(b));
figure;subplot(2,1,1);plot(a);
set(gca,'xlim',[1 int]);
subplot(2,1,2);plot(b);
set(gca,'xlim',[1 int]);
