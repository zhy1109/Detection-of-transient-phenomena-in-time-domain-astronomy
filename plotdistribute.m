function plotdistribute(lc,lc1,stratphoton,y_burst,endphoton,cp,titlesum)
num_use=max(size(lc));
tt_1 = ceil(max(size(stratphoton))); 
tt_2 = ceil(max(size(y_burst))+max(size(stratphoton)));
% cp_true = [tt_1 tt_2];
iu_1 = imresize(1: tt_1-1,0.15);
iu_2 = imresize(tt_1: tt_2,0.15);
iu_3 =imresize((tt_2+1): num_use,0.15);
nn_1 = length( iu_1 );
nn_2 = length( iu_2 );
nn_3 = length( iu_3 );
    xx_1 =imresize(stratphoton+1*cp/1*rand(1,max(size(stratphoton))),0.15);
    xx_2 = imresize(y_burst+1*cp/1*rand(1,max(size(y_burst))),0.15);
    xx_3 = imresize(endphoton+1*cp/1*rand(1,max(size(endphoton))),0.15);
    cp1=cp;
    xx = [ xx_1 xx_2 xx_3 ];
    % Find optimal block(s)
    num_use=max(size(xx));
    cell_data = zeros( num_use, 2);
    cell_data( :, 1) = xx';
    cell_data( :, 2) = 1 * ones(num_use ,1); 
    data_in.cell_data = cell_data;
    data_out = find_blocks( data_in );
    cp = data_out.change_points;
    cp=[max(size(xx_1)),max(size(xx_1))+max(size(xx_2))];
    num_blocks = length( cp ) + 1;
    if max(size(iu_2))~=max(size(xx_2))
        iu_2=iu_2(1:max(size(xx_2)));
    end
     iu= [iu_1/10,iu_2/10,iu_3/10];
     lc1=imresize(lc1,[1,max(size(iu))]) ;
    figure
   subplot(2,5,[1,2,6,7]);
%     subplot(1,3,1);
    plot( iu_1/10, xx_1, '+k')
    hold on
    plot( iu_2/10, xx_2, '.k')
    plot( iu_3/10, xx_3, '+k')
    hold on
    plot(iu,lc1+cp1/2.4,'LineWidth',1.5,'Color','k')
    xlabel('Time (s)');
    ylabel('Counts/s');
    set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
    hold on
    set(plot([iu(cp(1)-1),iu(cp(1)-1)],[min(lc1+cp1/2.4),max(lc1+cp1/2.4)], '--b' ),'LineWidth', 1.5)
    hold on
    set(plot([iu(cp(2)+1),iu(cp(2)+1)],[min(lc1+cp1/2.4),max(lc1+cp1/2.4)], '--b' ),'LineWidth', 1.5)
%    for ik = 1:length(cp)
%         set(plot(cp(ik)*[1 1], [min(lc1+cp1/2.4) max(lc1+cp1/2.4)], '-k' ),'LineWidth', 1.5 )
%    end
%     ploty( 0, ':k')
%     plotx( cp, '-k' )
    windowsize=100;%window size
stride=5;% Stride
z=floor(max(size(lc))/stride);
for i=1:z-windowsize/stride
    kurtosis5(i)=kurtosis(lc((i-1)*stride+1:windowsize+i*stride));%sliding window
end
subplot(253)
plot(kurtosis5,'LineWidth',1.5,'Color','k')
title('Kurtosis','fontname','Times New Roman','FontSize',20)
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
for i=1:z-windowsize/stride
    skewness5(i)=skewness(lc((i-1)*stride+1:windowsize+i*stride));
end
subplot(254)
plot(skewness5,'LineWidth',1.5,'Color','k')
title('Skewness','fontname','Times New Roman','FontSize',20)
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
for i=1:z-windowsize/stride
    mean5(i)=mean(lc((i-1)*stride+1:windowsize+i*stride));
end
subplot(2,5,(9))
plot(mean5,'LineWidth',1.5,'Color','k')
title('Mean','fontname','Times New Roman','FontSize',20)
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
for i=1:z-windowsize/stride
    var5(i)=var(lc((i-1)*stride+1:windowsize+i*stride));
end
for i=1:z-windowsize/stride
    rm(i)= rms(lc((i-1)*stride+1:windowsize+i*stride)); %均方根
    av = mean(lc((i-1)*stride+1:windowsize+i*stride)); %绝对值的平均值(整流平均值)
    SS(i)=rm(i)/av; %%%%%%波形因子
end
for i=1:z-windowsize/stride
    ma = max(lc((i-1)*stride+1:windowsize+i*stride)); %最大值
    mi = min(lc((i-1)*stride+1:windowsize+i*stride)); %最小值
    pk = ma-mi; %峰-峰值
    xr = mean(sqrt(abs(lc((i-1)*stride+1:windowsize+i*stride))))^2;
    L(i)=pk/xr;%%%%%裕度因子 
end
subplot(2,5,(10))
plot(var5,'LineWidth',1.5,'Color','k')
title('Variance','fontname','Times New Roman','FontSize',20)
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
subplot(2,5,(5))
plot(SS,'LineWidth',1.5,'Color','k')
title('Shape factor','fontname','Times New Roman','FontSize',20)
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
subplot(2,5,(8))
plot(L,'LineWidth',1.5,'Color','k')
title('Clearance factor','fontname','Times New Roman','FontSize',20)
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
% combinefeature=[kurtosis5,skewness5,mean5,var5];
% subplot(2,6,[5,6,11,12]);
% aa=combinefeature(1,:)'.*combinefeature(1,:);
% imagesc(aa)
% set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
% subplot(132)
% plot(kurtosis5,'LineWidth',1.5)
% hold on
% plot(skewness5,'LineWidth',1.5)
% hold on
% plot(mean5,'LineWidth',1.5)
% hold on
% plot(var5,'LineWidth',1.5)
% hold on
% iu_max=floor(max(iu));
% var5_max=max(size(var5));
% gap=iu_max-var5_max;
%     set(plot([iu(cp(1)-gap-8),iu(cp(1)-gap-8)],[0,1], '--k' ),'LineWidth', 1.5)
%     hold on
%     set(plot([iu(cp(2)-gap)+5,iu(cp(2)-gap)+5],[0,1], '--k' ),'LineWidth', 1.5)
% legend('Kurtosis','Skewness','Mean','Variance')
% subplot(133)
% plot(combinefeature,'LineWidth',1.5)
sgtitle(titlesum,'fontname','Times New Roman','FontSize',22)
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
kurtosis5= mapminmax(kurtosis5,0,1)+2;
skewness5= mapminmax(skewness5,0,1)+4;
mean5=mapminmax(mean5,0,1)+6;
var5=mapminmax(var5,0,1)+8;
SS=mapminmax(SS,0,1)+10;
L=mapminmax(L,0,1)+12;
figure
plot(kurtosis5,'LineWidth',1.5)
hold on
plot(skewness5,'LineWidth',1.5)
hold on
plot(SS,'LineWidth',1.5)
hold on
plot(L,'LineWidth',1.5)
hold on
plot(mean5,'LineWidth',1.5)
hold on
plot(var5,'LineWidth',1.5)
hold on
set(plot([300,300],[1,14], '--b' ),'LineWidth', 1.5)
hold on
set(plot([330,330],[1,14], '--b' ),'LineWidth', 1.5)
% hold on
% set(plot([305,305],[1,14], '--g' ),'LineWidth', 1.5)
% hold on
% set(plot([360,360],[1,14], '--g' ),'LineWidth', 1.5)
% hold on
% set(plot([310,310],[1,14], '--r' ),'LineWidth', 1.5)
% hold on
% set(plot([400,400],[1,14], '--r' ),'LineWidth', 1.5)
axis([-inf,inf,0,15])
legend('Kurtosis','Skewness','Shape factor','Clearance factor','Mean','Variance','Window')
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
end