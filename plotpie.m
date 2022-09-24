%%检测结果的饼状图
clear all
close all
y10401 = [52 3  16];
y20077 = [27 5  5];
y20078 = [48 16 38];
y20401 = [17 1 14];
y30075 = [3 0 14];
labels = {'Situation1','Situation2','Situation3'};
t = tiledlayout(1,5,'TileSpacing','compact');

% Create pie charts
ax1 = nexttile;
h1=pie(ax1,y10401);
title('10401-01')
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
ax2 = nexttile;
h2=pie(ax2,y20077);
title('20077-01')
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
ax2 = nexttile;
h3=pie(ax2,y20078);
title('20078-01')
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
ax2 = nexttile;
h4=pie(ax2,y20401);
title('20401-01')
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
ax2 = nexttile;
h5=pie(ax2,y30075);
title('30075-01')

% Create legend
lgd = legend(labels);
lgd.Layout.Tile = 'east';
colormap hsv
cm = [1 0 0; 0 1 0; 0 0 1];
colormap(cm)
set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')

% 
% 
% 
% width = 6;     % Width in inches
% height = 3;    % Height in inches
% alw = 0.75;    % AxesLineWidth
% fsz = 14;      % Fontsize
% lw = 1.5;      % LineWidth
% msz = 8;       % MarkerSize
% legl1=5;      % legen length size
% legl2=5;       % legen length size
% LOC='northwest'; % location of legend
% 
% %fig = figure; clf
% close all
% 
% %% Vs=340 Rl=200
% figure (1)
% subplot(1,2,1)
% hold on
% X1 = categorical({'S_1','S_2','L_p','L_r','C_{link}','D'});
% X1 = reordercats(X1,{'S_1','S_2','L_p','L_r','C_{link}','D'});
% X= [0.16 0.093  0.25 ; 0.06 0.125 0.185; 0 2.44 2.44 ; 0 1.8 1.8 ; 0 3.5 3.5 ;  0 1.6 1.6  ];
% bar(X1,X);
% %title('Second Subplot','fontName','Times')
% ylabel('Power losses (W)','fontName','times','FontSize',20);
% %xlabel('f_s/f_0','fontName','Time new Roman','FontSize',20);
% pos = get(gcf, 'Position');
% leg=legend('Switching Loss' ,'Conduction Loss','Total Loss','boxoff','Location',LOC);
% leg.ItemTokenSize = [legl1,legl2];
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
% set(gca, 'FontSize', fsz, 'LineWidth', alw,'fontname','times'); %<- Set propertieslegend('Conduction Loss','Switching Loss','Total Loss','fontName','Time new Roman');
% ylim([0 4])
% hold off
% 
% b2=subplot(2,2,2);
% X1= [(2.1*100/7.3)  (3.5*100/7.3) (3*100/7.3) ];
% explode = {'Inverter(28%)','Resonant tank(48%)','Rectifier (24%)'};
% pie(X1,explode);
% hold on
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
% set(gca,'fontName','times', 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
% dx0 = -0.06;
% dy0 = -0.4;
% dwithx = 0.1;
% dwithy = 0.23;
% set(b2,'position',get(b2,'position')+[dx0,dy0,dwithx,dwithy],'fontName','times')
% set(gca,'LooseInset', max(get(gca,'TightInset'), 0.08),'fontName','times')
% hold off
% set(b2,'position',get(b2,'position')+[dx0,dy0,dwithx,dwithy],'fontName','times')
%  % THIS LINE ADDED
% set(gca,'LooseInset', max(get(gca,'TightInset'), 0.08),'fontName','times')
% hold off
% 