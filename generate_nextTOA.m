function [ steps ] = generate_nextTOA(profile, current, E)
% profile:�����ź�  current:��ǰʱ���  E:ָ�������
% return:�ƶ��˼���
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
s=0;  %�ƶ��Ĳ���
d=0;  %�ƶ������������Ĺ�����
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

