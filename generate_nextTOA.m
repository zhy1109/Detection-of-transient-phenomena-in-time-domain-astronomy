function [ steps ] = generate_nextTOA(profile, current, E)
% profile:轮廓信号  current:当前时间点  E:指数随机数
% return:移动了几格
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
s=0;  %移动的步数
d=0;  %移动步数中增长的光子数
 while d<E
     s=s+1;
          if mod(s+current,1000)==0;
              d = d+profile(1000);
          else
              d = d+profile( mod(s+current,1000) );
          end
%       s=s+1;
%       d=d+yy(s)*Tb;
 end
steps = s;
end

