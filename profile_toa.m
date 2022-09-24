clear all
close all
fs=200;%����Ƶ��
Ts=1/fs;%��������
%%%���ɱ�׼����
t0=(1:1000)*Ts;%ʱ������
A1=0.01;
A2=0.013;
u1=0.35;
u2=0.6;
sig1=0.03;
sig2=0.04;
tao=0.0;              %%������ϵ��
signoise= 0.0;        %%��˹�����ı�׼��
sig_A=0;         %%������Ȳ����ı�׼��
T=0.1;      %%������
y1=lc_gauss_gen(t0,A1,u1,sig1,A2,u2,sig2,T,tao,signoise,sig_A);   %�������%fc:35.02Hz
fft1=abs(fft(y1-mean(y1)));
figure
plot(fft1)
y1=y1/(sum(y1)/50);%50�ǿ���һ�����ڹ�������
% ���������źţ�����Ƶ��1000Hz������1s��һ��������50�����ӡ�
numbers=50*max(t0)/T;%�������ܹ�����
% period_resolution = 0.0001;
%0.04 0.033s
%4 1s
diff=0;
curl = 1;%��ʼ��
TOAs = 1;
%%%�����������ĵ� 1000 bins��
for i=1:numbers-1
    E=exprnd(1);%���ܶ�
    steps = generate_nextTOA(y1, curl, E);%������һ��
    TOAs(i+1) = TOAs(i)+steps;
    curl = mod(curl+steps,1000);
    if curl==0
        curl = 1000;
    end
end
% ��TOAsת���ɹ������
len = max(size(TOAs));
lc = zeros(TOAs(len),1);
for i=1:len
    lc(TOAs(i))=1;
end
% lc=lc(1:80000);
train_data=cell(2,1);
for nn=1:1
% lc=lc(1:50000);%50000
% noise=(nn/300)*rand(length(lc),1);
% noise=0;
noise=rand(1,50000)>0.95;
noise=noise';
num_noise=sum(noise);%����������
num_lc=sum(lc);%������߹�����
ratio=num_lc/num_noise;
noise=0;
lc_n=lc+noise;
% lc_n=noise;
y=lc_n;
N=max(size(lc));
sig=y(1:N)';
%��һ��
% sig=(sig-mean(sig));
N2=length(sig);
NY=2^nextpow2(N2);
%ģ������
% sig=rand(1,30000);
 Nf=max(size(sig));
% [ACF,lags,bounds] = autocorr(sig,Nf-1);
% ACF(1)=0;
period_resolution=20*(1)/Nf;
% Nf=len;
f=(1:1:Nf)/fs;
% period_resolution=50*(1/1)/Nf;
% stt=1/(T+period_resolution*(-1000:1:1000));%�۵�����
%%%%��Ԫ�۵�%%%%%%%
 int=40;
 profile=epoch_folding_higeff(f,sig,T,int);
 figure
plot(abs(fft(sig-mean(sig))))
 figure
plot(profile)
 [row,col]=find(profile==0);
 b=unique(row);
 for i=row
     profile(row,:)=[];
 end
remaining_num= max(size(profile(:,1)));
 for i=1:remaining_num
     %     Hx(Z)=yyshang(profile1,20);
    K(i)=kurtosis(profile(i,:))-3;%%%���
    S(i)=skewness(profile(i,:));%%%ƫ��
%    profile1=detrend(profile1);
%     h=abs(hilbert(profile1)); 
    st(i)= std(profile(i,:)); %��׼��
    rm(i)= rms(profile(i,:)); %������
    av = mean(abs(profile(i,:))); %����ֵ��ƽ��ֵ(����ƽ��ֵ)
    SS(i)=rm(i)/av; %%%%%%��������
    ma = max(profile(i,:)); %���ֵ
    mi = min(profile(i,:)); %��Сֵ
    pk = ma-mi; %��-��ֵ
    xr = mean(sqrt(abs(profile(i,:))))^2;
    L(i)=pk/xr;%%%%%ԣ������ 
    Hx(i)=yyshang(profile(i,:),50);%%��Ϣ��
    H(i)=entropy(profile(i,:));%%��
    v(i)=var(profile(i,:));
%     [pmf,Hx]=calc_pmf(profile1);
%     if max(pmf)>0.1
%        index=find(max(pmf));
% %       pmf=zeros(100,1);
%       [index,~]=find(pmf==max(max(pmf)));
%       pmf(index)=(pmf(index+1)+pmf(index-1))/2;
%     end
%     pmf_matrix(:,Z)=pmf;
%     Hx_h(Z)=Hx;
 end
%  K=mapminmax(K);
%  S=mapminmax(S);
%  SS=mapminmax(SS);
%  L=mapminmax(L);
%  Hx=mapminmax(Hx);
%  H=mapminmax(H);
 data_train=[K;S;SS;L;Hx;H];
 train_data(nn-299,:)={data_train};
end
%%��׼������
XV = [train_data{:}];
mu = mean(XV,2);
sg = std(XV,[],2);
XTrainSD = train_data;
train_data = cellfun(@(x)(x-mu)./sg,XTrainSD,'UniformOutput',false);
num_cell=max(size(train_data));
% figure
% subplot(611)
% plot(K)
% subplot(612)
% plot(S)
% subplot(613)
% plot(SS)
% subplot(614)
% plot(L)
% subplot(615)
% plot(Hx)
% subplot(616)
% plot(H)
% subplot(717)
% plot(v)
% len=max(size(K));
%  stt=stt(1:len);%stt������
%  stt=1./stt;
% figure
% subplot(611)
% plot(stt,K,'LineWidth',1.5)
% axis([stt(1) stt(end) -inf,inf])
% set(gca, 'Fontname', 'Times New Roman','FontSize',14,'FontWeight','bold');
% subplot(612)
% plot(stt,S,'LineWidth',1.5)
% axis([stt(1) stt(end) -inf,inf])
% set(gca, 'Fontname', 'Times New Roman','FontSize',14,'FontWeight','bold');
% subplot(613)
% plot(stt,SS,'LineWidth',1.5)
% axis([stt(1) stt(end) -inf,inf])
% set(gca, 'Fontname', 'Times New Roman','FontSize',14,'FontWeight','bold');
% subplot(614)
% plot(stt,L,'LineWidth',1.5)
% axis([stt(1) stt(end) -inf,inf])
% set(gca, 'Fontname', 'Times New Roman','FontSize',14,'FontWeight','bold');
% subplot(615)
% plot(stt,Hx,'LineWidth',1.5)
% axis([stt(1) stt(end) -inf,inf])
% set(gca, 'Fontname', 'Times New Roman','FontSize',14,'FontWeight','bold');
% subplot(616)
% plot(stt,H,'LineWidth',1.5)
% axis([stt(1) stt(end) -inf,inf])
% xlabel('Frequency/Hz');
% %ylabel('Photon');%title('0dB simulation signal output frequency spectrum')
% set(gca, 'Fontname', 'Times New Roman','FontSize',14,'FontWeight','bold');
% % subplot(717)
% % plot(v)
% data_simu=[K(:,1+10*nn:300-10*nn)',S(:,1+10*nn:300-10*nn)',SS(:,1+10*nn:300-10*nn)',...
%     L(:,1+10*nn:300-10*nn)',Hx(:,1+10*nn:300-10*nn)',H(:,1+10*nn:300-10*nn)',v(:,1+10*nn:300-10*nn)'];
%k��� sƫ�� ss �������� l ԣ������ Hx��Ϣ�� h�� v����
%  cmd = ['save data_simu_noise',num2str(nn),'.mat data_simu'];
%     eval(cmd)
for nn_cell=1:num_cell
    clear zzz1
    clear zzz2
    clear zzz3
    clear zzz4
    clear zzz5
    clear zzz6
    clear data_combine
   zz=train_data{nn_cell,1}';
   zzz1(:,1)=rmoutliers(zz(:,1),'movmedian',5);%ȥ���쳣��
   zzz2(:,1)=rmoutliers(zz(:,2),'movmedian',5);
   zzz3(:,1)=rmoutliers(zz(:,3),'movmedian',5);
   zzz4(:,1)=rmoutliers(zz(:,4),'movmedian',5);
   zzz5(:,1)=rmoutliers(zz(:,5),'movmedian',5);
   zzz6(:,1)=rmoutliers(zz(:,6),'movmedian',5);
%     for i=1:6   
%         cmd = ['zzz',num2str(i),' = smooth(zzz',num2str(i),',7);'];%ƽ��
%        for j=1:1
%          eval(cmd)
%        end
%     end 
   data_combine=[zzz1;zzz2;zzz3;zzz4;zzz5;zzz6];
% data_combine=[zz(:,1)',zz(:,2)',zz(:,3)',zz(:,4)',zz(:,5)',zz(:,6)'];
   data_combine=smooth(data_combine,5);
    
%     for i=1:1
%         data_combine=smooth(data_combine,30);
%     end
    cmd=['save data_combine_train',num2str(nn_cell),' data_combine'];
    eval(cmd)
end
% data_train=data_train';
% clear zzz1
% clear zzz2
% clear zzz3
% clear zzz4
% clear zzz5
% clear zzz6
% zzz1(:,1)=rmoutliers(data_train(:,1),'movmedian',5);%ȥ���쳣��
% zzz2(:,1)=rmoutliers(data_train(:,2),'movmedian',5);
% zzz3(:,1)=rmoutliers(data_train(:,3),'movmedian',5);
% zzz4(:,1)=rmoutliers(data_train(:,4),'movmedian',5);
% zzz5(:,1)=rmoutliers(data_train(:,5),'movmedian',5);
% zzz6(:,1)=rmoutliers(data_train(:,6),'movmedian',5);
% for i=1:6   
%     cmd = ['zzz',num2str(i),' = smooth(zzz',num2str(i),',7);'];%ƽ��
%      for j=1:5
%     eval(cmd)
%      end
% end
% data_combine=[zzz1;zzz2;zzz3;zzz4;zzz5;zzz6];
% for i=1:5
%     data_combine=smooth(data_combine,30);
% end
% cmd=['save data_combine',num2str(nn-100),' data_combine'];
%  eval(cmd)
% 
for nnn=1:num_cell
    
 cmd=['load data_combine_train',num2str(nnn)];%���Ե�
    
    eval(cmd)
     data_combine = mapminmax(data_combine', 0, 1);%��һ��
     data_combine=data_combine';
    imwrite(imresize(data_combine',[100 120]),['train_positive_noise' num2str(nnn) '.png']);
end
