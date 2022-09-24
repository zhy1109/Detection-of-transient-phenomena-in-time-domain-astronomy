clear all
close all
%% generate noise
% starttime=50;
% endtime=50;
starttime=500*rand(1);
endtime=500*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
%%burst
% % ref:The Evolution of X-ray Bursts in the “Bursting Pulsar” GRO J1744–28
% % cp is the persistent emission rate.
%Cs is the burst intensity
Cs=5000*rand(1)+25000;
u1=6.5;
cp=1000+1000*rand(1);
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
zz=1+3*rand(1);
y_burst=Cs*gampdf(burst_t,zz,2)+cp;
% y=(1/((sqrt(2*pi))*sigma))*exp(-((x-a).^2)/(2*sigma.^2));
% %%%%dip 
% % ref:The Evolution of X-ray Bursts in the “Bursting Pulsar” GRO J1744–28
% %t0 is the start time of the dip
% %ad is the amplitude of the dip
% %d is the time at the local dip minimum
t0=0;
t_d=0:0.1:1;
ad=500+500*rand(1);
flux_dip=cp-ad*(t_d-t0)/(t_d(end)-t0);
% %%%%rise
% %ref: SIMULTANEOUS NuSTAR/CHANDRA OBSERVATIONS OF 
% %THE BURSTING PULSAR GRO J1744-28 DURING ITS THIRD REACTIVATION model
% ref[Younes et.al，2015]
%Cmin is the dip photon
t_r=t_d(end):0.1:10;
tau=5*rand(1);
flux_rise=cp-ad*(exp(-(t_r - t_d(end))/ tau));
t_all=[stratburst,burst_t+stratburst(end),t_d+burst_t(end)+stratburst(end),t_r+burst_t(end)+stratburst(end)...
    ,t_r(end)+burst_t(end)+stratburst(end)+endburst];
y_burst=[y_burst,flux_dip,flux_rise];
lc1=[stratphoton,y_burst,endphoton];
% noise=1000*rand(1,max(size(lc1)));
noiselength=max(size(lc1));
% [noise] = gennoisefuc(floor(noiselength/2),mean(cp),cp/10,noiselength);
tao=1;              %%周期振荡系数
sig_A=50;
y1=cp/20*qpo(tao,sig_A,4999);
noise=2000*rand(1,5000)+2000+y1;
lc=noise;
save('lc.txt','lc','-ascii')
% lc3=imresize(lc,[1,100000]);
% lc2=imresize(lc1,[1,10000]);
% t_all=imresize(t_all,[1,10000]);
genimage=statisticsouput(lc);
writeNPY(genimage,'burst_test.npy');%squeeze%生成训练集
copyfile('burst_test.npy','/Users/yangyang/Downloads/MSCRED-master/data/test/burst_test.npy')%生成训练集
% writeNPY(genimage,'burst_test.npy');%squeeze%生成训练集
% copyfile('burst_test.npy','/Users/yangyang/Downloads/MSCRED-master/data/test/burst_test.npy')
% writeNPY(['/Users/yangyang/Downloads/MSCRED-master/data/test/','burst_test.npy'],'genimage');
save lc lc
save t_all t_all
% aa=combinefeature(1,:)'.*combinefeature(1,:);
% figure
% imagesc(aa)