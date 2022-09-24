clear all
close all
aaaa=load('frequency_t1.txt');
figure
plot(aaaa((1:end),1),aaaa((1:end),2),'LineWidth',1)
set(gca,'xscale','log')
xlabel('Frequency [Hz]');
ylabel('Power');
set(gca,'FontName','Times New Roman','FontSize',18,'FontWeight','bold')
