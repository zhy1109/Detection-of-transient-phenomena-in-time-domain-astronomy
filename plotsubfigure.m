clear all
close all
ax1 = axes;
aa=load('10401-18.txt');%normal burst14335 14354 23387 23689
%microburst 20461
%  time=aa(:,1);
%  count=aa((1:end),2);
% time=0.1:0.1:max(size(aa))*0.1;
time=0.1:0.1:(28672)*0.1;
count=aa((1:28672),2);
plot(ax1,time,count,'LineWidth',1);
% 绘制子图
fig = ax1.Parent;
ax2 = copyobj(ax1,fig);
set(ax2,'Position',[.55 .65 .25 .25],'XLim',[680,710],'YLim',[2000,16000]);
% 绘制选框
rec = rectangle(ax1,'Position',[ax2.XLim(1), ax2.YLim(1), diff(ax2.XLim), diff(ax2.YLim)]);
% % % 绘制连线
% XLp = ax2.Position(1);
% XRp = sum(ax2.Position([1,3]));
% YDp = ax2.Position(2);
% YUp = sum(ax2.Position([2,4]));
% XLr = ax1.Position(1)+ax1.Position(3)/diff(ax1.XLim)*(rec.Position(1)-ax1.XLim(1));
% XRr = ax1.Position(1)+ax1.Position(3)/diff(ax1.XLim)*(sum(rec.Position([1,3]))-ax1.XLim(1));
% YDr = ax1.Position(2)+ax1.Position(4)/diff(ax1.YLim)*(rec.Position(2)-ax1.YLim(1));
% YUr = ax1.Position(2)+ax1.Position(4)/diff(ax1.YLim)*(sum(rec.Position([2,4]))-ax1.YLim(1));
% ano(1) = annotation('arrow',[0,0],[0,0]);
% ano(2) = annotation('arrow',[0,0],[0,0]);
% ano(3) = annotation('arrow',[0,0],[0,0]);
% ano(4) = annotation('arrow',[0,0],[0,0]);
% set(ano(1),'X',[XLr,XLp],'Y',[YDr,YDp],{'HeadLength','HeadWidth'},{0,0});
% set(ano(2),'X',[XLr,XLp],'Y',[YUr,YUp],{'HeadLength','HeadWidth'},{0,0});
% % set(ano(3),'X',[XRr,XRp],'Y',[YDr,YDp],{'HeadLength','HeadWidth'},{0,0});
% % set(ano(4),'X',[XRr,XRp],'Y',[YUr,YUp],{'HeadLength','HeadWidth'},{0,0});
% set(ano(1),'Visible','off');
% set(ano(4),'Visible','off');
fig = ax1.Parent;
ax2 = copyobj(ax1,fig);
set(ax2,'Position',[.55 .3 .25 .25],'XLim',[2322,2353],'YLim',[2000,16000]);
% 绘制选框
rec = rectangle(ax1,'Position',[ax2.XLim(1), ax2.YLim(1), diff(ax2.XLim), diff(ax2.YLim)]);
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
xlabel('Time (s)');
ylabel('Counts/s');
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
% set(gca,'XLim',[0 3000])
% set(gca,'YLim',[0 70000])