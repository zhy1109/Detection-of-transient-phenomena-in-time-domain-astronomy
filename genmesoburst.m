clear all
close all
% Mesoburst 
for i=1:1
starttime=500*rand(1);
endtime=500*rand(1);
stratburst=0:0.1:starttime;
endburst=0:0.1:endtime;
% Cs=4000+1000*rand(1);
Cs=2000*rand(1)+8000;
cp=1000+500*rand(1);
sig1=1;
stratphoton=cp*ones(1,length(stratburst));
endphoton=cp*ones(1,length(endburst));
burst_t=0:0.1:30;
zz1=2*rand(1)+3;
zz2=5*rand(1)+15;
y_burst=Cs*gampdf(burst_t,zz1,1);
y_burst1=Cs*gampdf(burst_t+1,zz2,1);
y_burst=y_burst+y_burst1+cp;
t_all=[stratburst,burst_t+stratburst(end),burst_t(end)+stratburst(end)+endburst];
tao=1;              %%周期振荡系数
sig_A=50;
length=20000;
y1=cp/20*qpo(tao,sig_A,max(size(stratphoton)-1));
y2=cp/20*qpo(tao,sig_A,max(size(endphoton))-1);
lc1=[stratphoton+y1,y_burst,endphoton+y2];
% lc1=[stratphoton,y_burst,endphoton];
% noise=cp/2*rand(1,max(size(lc1)));
noiselength=max(size(lc1));
% [noise] = gennoisefuc(floor(noiselength/2),mean(cp),cp/15,noiselength)/3;
noise=2000*rand(1,noiselength)+3000;
lc=lc1+noise;
% lc3(i,:)=imresize(lc,[1,1000]);
% lc2(i,:)=imresize(lc1,[1,1000]);
% t_all=imresize(t_all,[1,1000]);
end
genimage=statisticsouput(lc);
writeNPY(genimage,'burst_test.npy');
copyfile('burst_test.npy','/Users/yangyang/Downloads/MSCRED-master/data/test/burst_test.npy')
% writeNPY(['/Users/yangyang/Downloads/MSCRED-master/data/test/','burst_test.npy'],'genimage');
save lc lc
save t_all t_all
% figure
% for j = 1:10
%      plot(t_all,lc2(j,:));
%      hold on
% end