function zz=statisticsouput(lc2)
windowsize=500;%window size
stride=2;% Stride
windownum1=floor((max(size(lc2))-max(windowsize))/max(stride));%可以走多少步
for j=1:max(size(lc2(:,1)))
    lc=lc2(j,:);
for i=1:windownum1
    kurtosis1(i)=kurtosis(lc((i-1)*stride+1:windowsize+i*stride));
end
for i=1:windownum1
    skewness1(i)=skewness(lc((i-1)*stride+1:windowsize+i*stride));
end
for i=1:windownum1
    mean1(i)=mean(lc((i-1)*stride+1:windowsize+i*stride));
end
for i=1:windownum1
    var1(i)=var(lc((i-1)*stride+1:windowsize+i*stride));
end
for i=1:windownum1
    rm(i)= rms(lc((i-1)*stride+1:windowsize+i*stride)); %均方根
    av = mean(lc((i-1)*stride+1:windowsize+i*stride)); %绝对值的平均值(整流平均值)
    SS(i)=rm(i)/av; %%%%%%波形因子
end
for i=1:windownum1
    ma = max(lc((i-1)*stride+1:windowsize+i*stride)); %最大值
    mi = min(lc((i-1)*stride+1:windowsize+i*stride)); %最小值
    pk = ma-mi; %峰-峰值
    xr = mean(sqrt(abs(lc((i-1)*stride+1:windowsize+i*stride))))^2;
    L(i)=pk/xr;%%%%%裕度因子 
end
% kurtosis1(find(kurtosis1==0))=[];
% skewness1(find(skewness1==0))=[];
% mean1(find(mean1==0))=[];
% var1(find(var1==0))=[];
% SS(find(SS==0))=[];
% L(find(L==0))=[];
kurtosis1= mapminmax(kurtosis1,0,1);
skewness1= mapminmax(skewness1,0,1);
mean1=mapminmax(mean1,0,1);
var1=mapminmax(var1,0,1);
SS=mapminmax(SS,0,1);
L=mapminmax(L,0,1);
combinefeature=[kurtosis1;skewness1;mean1;var1;SS;L];
% combinefeature=[kurtosis1,skewness1,mean1,var1,SS,L];
end
% %设计的窗口大小
% windowsize2=20;
% windowsize3=30;%设计的窗口大小
% windownum=floor(max(size(kurtosis1))/window);
%  forstride2
% stride2=[10];%这个是步长，第一个是10步，第二个是20步，找到其中的时间联系。
stride2=[2,4,6,8,10];
windowsize=[30,60,90];
for jj=windowsize%
windownum=floor((max(size(kurtosis1))-max(windowsize))/max(stride2));%可以走多少步
for zzz=1:windownum-max(stride2)
    for jjj=stride2
        zz(zzz,jjj/min(stride2),:,:,jj/min(windowsize))=imresize(combinefeature(:,((zzz-1)*max(stride2)+jjj:jj+zzz*max(stride2)+jjj))'*...
        combinefeature(:,((zzz-1)*max(stride2)+jjj:jj+zzz*max(stride2)+jjj)),[30,30]);
    end
end
end
% for zz=1:max(size(kurtosis1))
% aa=combinefeature(:,zz).*combinefeature(:,zz)';
% image(zz,:,:,k/50-2)=aa;
% end
end
