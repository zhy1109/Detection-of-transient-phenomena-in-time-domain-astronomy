function [time_data4] = gennoisefuc(N,noisemean,noisestandard,noiselength)
mu = 0.1; %发生脉冲的平均时间间隔
% N = 500; %整个仿真发生脉冲的个数
t_tick = 0.1; %一个脉冲持续的时间
time_between = exprnd(1*mu, N, 1); % 生成脉冲的时间
time = cumsum( time_between ); % actual time of events is the cumulative sum of waiting times
time = round( time/t_tick )*t_tick; % round
% time_data1 = [time'; ones(1,N)]'; % a matrix containing event times + '1' per each event
time_data1 = [time'; abs(normrnd(noisemean,noisestandard,1,N))]';%生成峰值不同的数 均值为1 标准差为0.5 的1*N矩阵
% k=0:0.02048:50;
% time_data1=time_data1(:,end);
% time_data1 = [time'; exp(-k/50)]';
time_data2 = [imresize((0:t_tick:max(time))',[noiselength-max(size(time_data1)),1]) ...
    zeros( noiselength-max(size(time_data1)), 1 ) ]; 
% time_data2 =[zeros( noiselength-max(size(time_data1)), 1 ) ]; 
% a matrix containing non-event time ticks + '0' per each time tick. 
% This is used for plotting
time_data3=[time_data1; time_data2]; % concatenate both matrices
time_data4=sortrows(time_data3,1); % sort according to time (column 1)
time_data4=time_data4(:,end)';