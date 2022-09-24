clear all
close all
%% normal burst
starttime=500*rand(1);
endtime=500*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
%%burst
% % ref:The Evolution of X-ray Bursts in the “Bursting Pulsar” GRO J1744–28
% % cp is the persistent emission rate.
%Cs is the burst intensity
Cs=30000;
u1=6.5;
cp=2000;
sig1=1;
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
% burst_t=0:0.01:30;
% alpha=1;
% y_burst=Cs*(1/sqrt(2*pi*(sig1))*exp(-(burst_t-u1).^2/(2*(sig1^.2))))+cp;
% skew distribute
% yy=(1/pi)*(exp(-(burst_t-u1).^2)/2*sig1^.2)*(exp(-(10*((burst_t-u1)/sig1)).^2/2));
% yy=(1/(sig1*pi))*exp(-((burst_t-u1).^2)/(2*sig1.^2)).*(exp(-(alpha*((burst_t-u1)/sig1)).^2/2));
% fx=exp(-(t^2)/2);
% yy=(1/(sig1*pi))*exp(-((burst_t-u1).^2)/(2*sig1.^2)).*int(fx,t,0,alpha((burst_t-u1)/sig1));
burst_t=0:0.1:20;
y_burst=Cs*gampdf(burst_t,3,2)+cp;
% y=(1/((sqrt(2*pi))*sigma))*exp(-((x-a).^2)/(2*sigma.^2));
% %%%%dip 
% % ref:The Evolution of X-ray Bursts in the “Bursting Pulsar” GRO J1744–28
% %t0 is the start time of the dip
% %ad is the amplitude of the dip
% %d is the time at the local dip minimum
d=1;
t0=0;
t_d=0:0.1:1;
ad=1000;
flux_dip=cp-ad*(t_d-t0)/(t_d(end)-t0);
% %%%%rise
% %ref: SIMULTANEOUS NuSTAR/CHANDRA OBSERVATIONS OF 
% %THE BURSTING PULSAR GRO J1744-28 DURING ITS THIRD REACTIVATION model
% ref[Younes et.al，2015]
%Cmin is the dip photon
t_r=t_d(end):0.1:10;
Cmin=1000;
tau=1;
% flux_rise=(cp - Cmin)*(1 - exp(-(t_r - t_d(end))/ tau))+ Cmin;
flux_rise=cp-ad*(exp(-(t_r - t_d(end))/ tau));
t_all=[stratburst,burst_t+stratburst(end),t_d+burst_t(end)+stratburst(end),t_r+burst_t(end)+stratburst(end)...
    ,t_r(end)+burst_t(end)+stratburst(end)+endburst];
y_burst=[y_burst,flux_dip,flux_rise];
lc1=[stratphoton,y_burst,endphoton];
% noise=1000*rand(1,max(size(lc1)));
noiselength=max(size(lc1));
[noise] = gennoisefuc(floor(noiselength/2),mean(cp),cp/15,noiselength);
lc=lc1+noise;
% lc=noise;
plotdistribute(lc,lc1,stratphoton,y_burst,endphoton,cp,'Normal Burst');
%% mini burst
starttime=100*rand(1);
endtime=100*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
Cs=8000;
u1=6.5;
cp=1500;
sig1=1;
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
burst_t=0:0.1:15;
%burst
alpha=1;
y_burst=Cs*(1/sqrt(2*pi*(sig1))*exp(-(burst_t-u1).^2/(2*(sig1^.2))))+cp;
%dip
d=1;
t0=0;
t_d=0:0.1:1;
ad=500;
flux_dip=cp-ad*(t_d-t0)/(t_d(end)-t0);
%rise
t_r=t_d(end):0.1:10;
Cmin=1500;
tau=1;
flux_rise=cp -ad*(exp(-(t_r - t_d(end))/ tau));
t_all=[stratburst,burst_t+stratburst(end),t_d+burst_t(end)+stratburst(end),t_r+burst_t(end)+stratburst(end)...
    ,t_r(end)+burst_t(end)+stratburst(end)+endburst];
y_burst=[y_burst,flux_dip,flux_rise];
lc1=[stratphoton,y_burst,endphoton];
noise=cp*rand(1,max(size(lc1)));
lc=lc1+noise;
figure
plot(t_all,lc)
plotdistribute(lc,lc1,stratphoton,y_burst,endphoton,cp,'Mini Burst');
% Mesoburst 
starttime=100*rand(1);
endtime=100*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
Cs=2500;
u1=6.5;
cp=300;
sig1=1;
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
burst_t=0:0.1:30;
y_burst=Cs*gampdf(burst_t,5,1)/2;
y_burst1=Cs*gampdf(burst_t+1,14,1)/2;
y_burst=y_burst+y_burst1+300;
t_all=[stratburst,burst_t+stratburst(end),burst_t(end)+stratburst(end)+endburst];
lc1=[stratphoton,y_burst,endphoton];
noise=cp/3*rand(1,max(size(lc1)));
lc=lc1+noise;
figure
plot(t_all,lc)
plotdistribute(lc,lc1,stratphoton,y_burst,endphoton,cp,'Mesoburst');
% Structured “Bursts
sig1=1;
u1=6.5;
starttime=100*rand(1);
endtime=100*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
Cs=200;
cp=100;
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
a=0;sigma=5; % 均值a=-6 sigma越大峰越宽
% burst_t=-15:0.1:15;
% y_burst=Cs*(1/((sqrt(2*pi))*sigma))*exp(-((burst_t-a).^2)/(2*sigma.^2))+cp;
burst_t=0:0.1:15;
beta=1;
y_burst=Cs*(beta/(sqrt(2*pi)*(sig1))*exp(-(burst_t-u1).^2/(2*(sig1^.2))))+cp;
t_all=[stratburst,burst_t+stratburst(end),burst_t(end)+stratburst(end)+endburst];
lc1=[stratphoton,y_burst,endphoton];
% noise=0.5*cp/1*rand(1,max(size(lc1)));
noiselength=max(size(lc1));
[noise] = gennoisefuc(floor(noiselength/2),mean(cp),cp/15,noiselength);
lc=lc1+noise;
% lc=noise;
figure
plot(t_all,lc)
plotdistribute(lc,lc1,stratphoton,y_burst,endphoton,cp,'Structured Burst');
% % Microbursts
sig1=1;
u1=6.5;
starttime=100*rand(1);
endtime=100*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
Cs=70+120*rand(1);
cp=50+100*rand(1);
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
a=0;sigma=5; % 均值a=-6 sigma越大峰越宽
% burst_t=-15:0.1:15;
% % y_burst=Cs*(1/((sqrt(2*pi))*sigma))*exp(-((burst_t-a).^2)/(2*sigma.^2))+cp;
burst_t=0:0.1:15;
beta=1;
y_burst=Cs*(beta/(sqrt(2*pi)*(sig1))*exp(-(burst_t-u1).^2/(2*(sig1^.2))))+cp;
t_all=[stratburst,burst_t+stratburst(end),burst_t(end)+stratburst(end)+endburst];
lc1=[stratphoton,y_burst,endphoton];
% noise=0.7*cp/1*rand(1,max(size(lc1)));
noiselength=max(size(lc1));
[noise] = gennoisefuc(floor(noiselength/2),mean(cp),cp/15,noiselength);
lc=lc1+noise;
figure
plot(t_all,lc)
plotdistribute(lc,lc1,stratphoton,y_burst,endphoton,cp,'Microburst');
