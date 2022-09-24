clear all
close all
load lc.mat
load t_all.mat
% t_all=imresize(t_all,[1,8220]);
aa=load('losstestchafen.txt');
aaa=load('losstest.txt');
% index1=find(aa==(max(aa)));
num=max(size(aa));
t1=1:1:num;
t2=1:1:num+1;
figure
plot(t1,abs(aa),'-*','LineWidth', 1.5)%,
xlabel('No.window');
xlim([0,max(t1)])
% ylabel('Difference spectrum');
set(gca,'FontName','Times New Roman','FontSize',24,'FontWeight','bold')
% hold on
% plot(t2,aaa,'-o')
xlim([0,max(t1)])
thr=mean(aa)+5*std(aa);
hold on
set(plot([0,max(size(aa))],[thr,thr], '--r' ),'LineWidth', 1.5)
% xlabel('No.window');
% ylabel('Loss');
% legend('Error Difference spectrum','Threshold')
set(gca,'FontName','Times New Roman','FontSize',24,'FontWeight','bold')
index=find(thr<abs(aa));
if  isempty(index)==1
     disp('no burst')
else
if max(size(index))>2
    for i=1:max(size(index))-1
       interval(i)=index(i+1)-index(i); 
    end
    find1=interval>30;
    if ismember(1,find1)%将返回一个在该位置包含逻辑值 1 (true) 的数组
        index2=find(find1==1);
        [index11,~]=find(abs(aa)==min(abs(aa(1:index(index2)))));
        [index12,~]=find(abs(aa)==min(abs(aa(index(index2+1):index(end)))));
        index1=[index11+1,index12-1];
    else
        index1=find(abs(aa)==min(abs(aa(index(1):index(end)))));
    end
else
    index1=find(abs(aa)==min(abs(aa(index(1):index(end)))));
end
% [1:index2(1),1:index2(2)]
%    index1=[index(1),index(i+1)]; 
%     index1=index(1);
%         
%             
%         else
%             [index1,~]=find(abs(aa)==max(abs(aa(index))));
%         end
%     end
% else 
%     index1=index(1);
% end
% index1=index(1);
stratburst=floor(max(size(lc))/max(size(aa)))*(index1);
% stratburst=floor(max(size(lc))/max(size(aa))-15)*(index1);
% stratburst=floor(max(size(lc))/max(size(aa))+3)*(index1);
index2=t_all(stratburst);
figure
% plot(iu,lc1+cp1/2.4,'LineWidth',1.5,'Color','k')
plot(t_all,lc(1:max(size(t_all))),'LineWidth',1.5)
xlim([0,max(t_all)])
for i=1:max(size(index2))
hold on
set(plot([index2(i),index2(i)],[min(lc-(mean(lc)/10)),max(lc+(mean(lc))/10)], '--r' ),'LineWidth', 1.5)
hold on
set(plot([index2(i),index2(i)],[min(lc-(mean(lc)/10)),max(lc+(mean(lc))/10)], '--r' ),'LineWidth', 1.5)
end
set(gca,'FontName','Times New Roman','FontSize',24,'FontWeight','bold')
xlabel('Time (s)');
ylabel('Counts/s');
ylim([min(lc-(mean(lc)/10)),max(lc+(mean(lc))/10)])
set(gca,'FontName','Times New Roman','FontSize',24,'FontWeight','bold')
end
% figure
% plot(t2,aaa,'-o','Color','k')
% hold on
% set(plot([15,15],[0.5,3.5], '--r' ),'LineWidth', 1.5)
% hold on
% set(plot([30,30],[0.5,3.5], '--r' ),'LineWidth', 1.5)
% xlabel('No.window');
% ylabel('Error');
% set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
% figure
% plot(t_all,lc,'LineWidth',1.5,'Color','k')
% xlabel('Time (s)');
% ylabel('Counts/s');
% set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')