% Simulate Shot Noise散粒噪声模型
% Here we generate a Poisson Impulse Process (a kind of white noise)
clear all; 
close all;
%%binned in time intervals of 0.005 200Hz
mu = 0.1; %发生脉冲的平均时间间隔
N = 500; %整个仿真发生脉冲的个数
t_tick = 0.1; %一个脉冲持续的时间
time_between = exprnd(1*mu, N, 1); % 生成脉冲的时间
time = cumsum( time_between ); % actual time of events is the cumulative sum of waiting times
time = round( time/t_tick )*t_tick; % round
% time_data1 = [time'; ones(1,N)]'; % a matrix containing event times + '1' per each event
 time_data1 = [time'; abs(normrnd(40,40,1,N))]';%生成峰值不同的数 均值为1 标准差为0.5 的1*N矩阵
% k=0:0.02048:50;
% time_data1 = [time'; exp(-k/50)]';
time_data2 = [ (0:t_tick:max(time) )'  ...
    zeros( 1+max(time)/t_tick, 1 ) ]; 
% a matrix containing non-event time ticks + '0' per each time tick. 
% This is used for plotting
time_data3=[time_data1; time_data2]; % concatenate both matrices
time_data4=sortrows(time_data3,1); % sort according to time (column 1)
plot(time_data4(:,1), time_data4(:,2) )
% ylim( [-0.1 1.1]); 
ylabel('Events'); title(['Average=' num2str(1/mu) ' events/second']);

%% Now plot fft of the generated Poisson Impulse Process (white noise)
% Y=abs(fft(time_data4(:,2)));
% f=0:1/max(time):0.5/t_tick;
% figure
% plot( f,Y(1:length(f)) )
% ylabel('psd'); xlabel('frequency [Hz]'); title('PSD');xlim([-10 500]); ylim([-1 54])