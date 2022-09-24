close all
clear all
% for i=1:1
% starttime=200;
% endtime=200;
% stratburst=0:0.1:starttime;
% endburst=0:0.1:endtime;
% Cs=5000*rand(1)+60000;
% u1=6.5;
% cp=1000+500*rand(1);
% sig1=1;
% stratphoton=cp*ones(1,length(stratburst));
% endphoton=cp*ones(1,length(endburst));
% burst_t=0:0.1:20;
% zz=1+3*rand(1);
% y_burst=Cs*gampdf(burst_t,zz,2)+cp;
% t0=0;
% t_d=0:0.1:2;
% ad=200+200*rand(1);
% flux_dip=cp-ad*(t_d-t0)/(t_d(end)-t0);
% t_r=t_d(end):0.1:100;
% % tau=5*rand(1);
% tau=40+50*rand(1);
% flux_rise=cp-ad*(exp(-(t_r - t_d(end))/ tau));
% t_all=[stratburst,burst_t+stratburst(end),t_d+burst_t(end)+stratburst(end),t_r+burst_t(end)+stratburst(end)...
%     ,t_r(end)+burst_t(end)+stratburst(end)+endburst];
% y_burst=[y_burst,flux_dip,flux_rise];
% tao=1;              %%周期振荡系数
% sig_A=50;
% length=20000;
% y1=cp/20*qpo(tao,sig_A,max(size(stratphoton)-1));
% y2=cp/20*qpo(tao,sig_A,max(size(endphoton))-1);
% lc1=[stratphoton+y1,y_burst,endphoton+y2];
% noiselength=max(size(lc1));
% noise=2000*rand(1,noiselength)+3000;
% lc=lc1+noise;
% end
aa=load('10401-24.txt');
lc=aa((1:14000),end)';
time=0.1:0.1:(max(size(lc)))*0.1;
count=lc;
figure
plot(time,count,'LineWidth',1);
xlabel('Time (s)');
ylabel('Counts/s');
xlim([0, max(time)]);
title('')
set(gca,'FontName','Times New Roman','FontSize',24,'FontWeight','bold')
%set(gca,'position',[0 0 1 1]);%忽略坐标轴
genimage=statisticsouput(lc);

imagesc(squeeze(genimage(80,1,:,:,3)))