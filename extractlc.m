%%制作数据
clear all
close all
% aa=load('xp2007701_e3_n2a_t1.txt');
aa=load('xp1040101_e3_n2a_t1.txt');
% aa=load('xp2007801_e3_n2a_t1.txt');
% aa=load('xp2040101_e3_n2a_t1.txt');
% aa=load('xp3007501_e3_n2a_t1.txt');%4
time=aa(:,1);
for i=1:max(size(aa))-1
time1(i)=time(i+1)-time(i);
end
aa_lc=aa(:,2);
index=(find(time1>42));
for i=1:max(size(index))-2
aaa(:,i)=imresize(aa_lc((index(i)+1):(index(i+1))),[4096,1]);
end
aaa=aaa';
% for i=1:length(aaa(:,1))
% lc=aaa(i,:);
% save(['/Users/yangyang/Documents/MATLAB/lc/type-i-model/datarxte/','30075-',num2str(i),'.txt'],'lc')
% end
lc=aaa(2,:); 
for i=1:3
figure
plot(aaa(i,:))
end
genimage=statisticsouput(lc);
t_all=0.1:0.1:max(size(lc))/10;
writeNPY(genimage,'burst_test.npy');
copyfile('burst_test.npy','/Users/yangyang/Downloads/MSCRED-master/data/test/burst_test.npy')
save lc lc
save t_all t_all