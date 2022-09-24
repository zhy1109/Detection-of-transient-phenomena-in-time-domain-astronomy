clear all
close all
for i=1:1
starttime=500*rand(1);
endtime=500*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
Cs=4000*rand(1)+6000;
u1=6.5;
cp=1000+500*rand(1);
% sig1=1;
sig1=3*rand(1);
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
burst_t=0:0.1:10;
%burst
y_burst=Cs*(1/sqrt(2*pi*(sig1))*exp(-(burst_t-u1).^2/(2*(sig1^.2))))+cp;
%dip
t0=0;
t_d=0:0.1:2;
ad=300+300*rand(1);
flux_dip=cp-(ad-200)*(t_d-t0)/(t_d(end)-t0);
%rise
t_r=0.1:0.1:100;
% tau=5*rand(1);
tau=10+50*rand(1);
flux_rise=cp-ad*(exp(-(t_r-t_d(end))/tau));
gap=min(flux_dip)-min(flux_rise);
flux_rise=flux_rise+gap/2;
t_all=[stratburst,burst_t+stratburst(end),t_d+burst_t(end)+stratburst(end),t_r+burst_t(end)+stratburst(end)...
    ,t_r(end)+burst_t(end)+stratburst(end)+endburst];
y_burst=[y_burst,flux_dip,flux_rise];
tao=1;              %%周期振荡系数
sig_A=50;
length=20000;
y1=cp/20*qpo(tao,sig_A,max(size(stratphoton)-1));
y2=cp/20*qpo(tao,sig_A,max(size(endphoton))-1);
lc1=[stratphoton+y1,y_burst,endphoton+y2];
% lc1=[stratphoton,y_burst,endphoton];
% noise=1000*rand(1,max(size(lc1)));
noiselength=max(size(lc1));
% [noise] = gennoisefuc(floor(noiselength/2),mean(cp),cp/10,noiselength);
noise=2000*rand(1,noiselength)+3000;
lc=lc1+noise;
% lc3(i,:)=imresize(lc,[1,1000]);
% lc2(i,:)=imresize(lc1,[1,1000]);
% t_all=imresize(t_all,[1,1000]);
end
save('lc.txt','lc','-ascii')
load lc.txt
genimage=statisticsouput(lc);
writeNPY(genimage,'burst_test.npy');%squeeze
copyfile('burst_test.npy','/Users/yangyang/Downloads/MSCRED-master/data/test/burst_test.npy')
% writeNPY(['/Users/yangyang/Downloads/MSCRED-master/data/test/','burst_test.npy'],'genimage');
save lc lc
save t_all t_all
% figure
% for j = 1:10
%      plot(t_all,lc2(j,:));
%      hold on
% end