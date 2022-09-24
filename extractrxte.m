%%制作数据
clear all
close all
aa=load('10401-18.txt');
figure
plot(aa(:,end))
aa=aa((8500:14000),:);
time_size=max(size(aa(:,1)));
for i=1:time_size-1
time(i)=(i-1)*0.125;
end
aa_lc=aa(:,2);
% index=(find(time1>42));
% for i=1:max(size(index))-2
% aaa(:,i)=imresize(aa_lc((index(i)+1):(index(i+1))),[4096,1]);
% end
% aaa=aaa';
% for i=1:length(aaa(:,1))
% lc=aaa(i,:);
% save(['/Users/yangyang/Documents/MATLAB/lc/type-i-model/datarxte/','30075-',num2str(i),'.txt'],'lc')
% end
lc=aa_lc';
genimage=statisticsouput(lc);
t_all=time;
writeNPY(genimage,'burst_test.npy');
copyfile('burst_test.npy','/Users/yangyang/Downloads/MSCRED-master/data/test/burst_test.npy')
save lc lc
save t_all t_all