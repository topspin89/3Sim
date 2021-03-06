function Z=Gl_PRM
Nl=1;
Ns=5;                % ���������� �������
T=100;         % ������ ����������.
dt=0;                % ��� �� ������� % ���� 0- �� ������������ ���
ndt=1;
g=9.81e-5;

%% ��� ���������
as=[2,2,1];                             % ������� � �����  w-o-g
aw=[0.1,1,10];                          % ������� ����� ������� � ����� w-o-g
 
ts=[1,1,1];                             % ������� � ��������  w-o-g
tw=[1,1,10];                            % ������� ����� ������� � ������� w-o-g
kms=0*[1,1,1,1]*1e-3;                   % ����. ��� ��-� ���������� ����-����.��. -���.��.-������� ��.

Swr=0.25;                               %���������� ���� �������
Sor=0.2625;                             %���������� ����� �������

SwrC=0;                                 %���������� ���� �������
SorC=0;                                 %���������� ����� �������

mu=[1,300,0.1,1];                       % �������� w-o-g-p
   %�      mu
mup=[0,  mu(1), 0.002,20];                  % �������� ��������
Ro=[1.04,0.95,0.00066,3,2.7]*1000;      % ��������� ����-�����-���-��������-�����
zc=[1e-6,1e-5,1e-3,1e-6,1e-6,1e-6]*0;   % ����������� ����-�����-���-��������-�����-����            
Bo=[1,1,0.5,1,1];                       % �������� ������������

%% ��������� �������
dh=0.05;                              % ����������� ����. ���������� �������
hg=0.0005;                              % ����������� ���. ���������� �������

Kc=1e+3;                                % ������������� ���������� �������
Kg=1e+2;                                % ������������� �������������� �������
Kd=1e+1;                                % ������������� ������� ����� 

fC=[0,0,0];                             %���� �� ������� ����.��. - ���.��. - ������� �����
ddol=0.1;				
drob=300; 
Alp_C=100;                                % ����. ������ ������������ ������� � ���

 %% �������� ��������� 

lam=[0.65,0.13,0.06,0.5,0.8]*3600*24;    % ����. ����������������
Cp=[4.2,1.9,2.22,0.75,0.75]*1000;        % �����������


%% ������ � ���������
Z.Nl=Nl;
Z.as=as;
Z.aw=[aw,Swr,Sor];
Z.ts=ts;
Z.tw=[tw,SwrC,SorC];
Z.mu=mu;
Z.Ns=Ns;
Z.Ta=T;
Z.dt=dt;
Z.ndt=ndt;
Z.Ro=Ro;
Z.lam=lam;
Z.Cp=Cp;
Z.dh=dh;
Z.Hg=hg;
Z.Kc=Kc;
Z.Kg=Kg;
Z.Kd=Kd;
Z.zc=zc;
Z.Bo=Bo;
Z.mup=[mup(1:2);mup(3:4)];
Z.kms=kms;
Z.g=g;
Z.fC=fC;
Z.drob=drob;
Z.ddol=ddol;
Z.Alp_C=Alp_C;

[Z.Sc,Z.Fc]=sum2bol_Dima(Z.aw,Z.as,Z.mu);
[Z.Sc2,Z.Fc2]=sum2bol_Dima(Z.tw,Z.ts,Z.mu);
end
function [Sc,Fc]=sum2bol_Dima(AW,as,mu)
Swr=AW(4);
Sor=AW(5);
aw=AW(1:3);

Sw=Swr:0.001:(1-Sor);

SW=(Sw-Swr)./(1-Sor-Swr);
ko=(1-SW).^as(2);
kw=aw(1)*SW.^as(1);

gam=mu(1)/mu(2);

f=kw./(gam*ko+kw);
F=diff(f)./diff(Sw);
% figure(101);plot(Sw(2:end),F);
v=find(F==max(F));

Sc=Sw(v(1));
Fc=F(v(1));
end
