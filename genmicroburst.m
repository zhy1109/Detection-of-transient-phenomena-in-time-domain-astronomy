close all
clear all
% % Microbursts
for i=1:1
sig1=1;
u1=6.5;
starttime=500*rand(1);
endtime=500*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
Cs=4000+500*rand(1);%
cp=1000+500*rand(1);
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
a=0;sigma=5; % 均值a=-6 sigma越大峰越宽
% burst_t=-15:0.1:15;
% % y_burst=Cs*(1/((sqrt(2*pi))*sigma))*exp(-((burst_t-a).^2)/(2*sigma.^2))+cp;
burst_t=3:0.1:10;
beta=1;
y_burst=Cs*(beta/(sqrt(2*pi)*(sig1))*exp(-(burst_t-u1).^2/(2*(sig1^.2))))+cp;
t_all=[stratburst,burst_t+stratburst(end),burst_t(end)+stratburst(end)+endburst];
tao=1;              %%周期振荡系数
sig_A=50;
length=20000;
y1=cp/20*qpo(tao,sig_A,max(size(stratphoton)-1));
y2=cp/20*qpo(tao,sig_A,max(size(endphoton))-1);
lc1=[stratphoton+y1,y_burst,endphoton+y2];
% noise=0.8*cp/1*rand(1,max(size(lc1)));
noiselength=max(size(lc1));
% [noise] = gennoisefuc(floor(noiselength/2),mean(cp),cp/10,noiselength);
noise=2000*rand(1,noiselength)+3000;
lc=lc1+noise;
% lc=noise;
% lc3(i,:)=imresize(lc,[1,1000]);
% lc2(i,:)=imresize(lc1,[1,1000]);
% t_all=imresize(t_all,[1,1000]);
end
genimage=statisticsouput(lc);
writeNPY(genimage,'burst_test.npy');%squeeze
copyfile('burst_test.npy','/Users/yangyang/Downloads/MSCRED-master/data/test/burst_test.npy')
% writeNPY(['/Users/yangyang/Downloads/MSCRED-master/data/test/','burst_test.npy'],'genimage');
save lc lc
save t_all t_all
% [y_final f_final kurt] = med2d(lc',30,100,[],'valid',1);
% figure
% for j = 1:10
%      plot(t_all,lc2(j,:));
%      hold on
% end