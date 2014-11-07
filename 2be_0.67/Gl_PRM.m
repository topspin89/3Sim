function Z=Gl_PRM
Nl=1;
Ns=5;                % ���������� �������
T=10;%100*365;            % ������ ����������.
dt=0;                % ��� �� ������� % ���� 0- �� ������������ ���
Ta=T;
ndt=1;

%% ��� ���������
as=[2,2,1];                             % ������� � �����  w-o-g
aw=[0.07,1,10];                          % ������� ����� ������� � ����� w-o-g
 
ts=[1,1,1];                               % ������� � ��������  w-o-g
tw=[1,1,10];                            % ������� ����� ������� � ������� w-o-g
kms=0*[1,1,1]*1e-3;                       % ����. ��� ��-� ����������

Swr=0.25;                               %���������� ���� �������
Sor=0.2625;                             %���������� ����� �������

SwrC=0;                                 %���������� ���� �������
SorC=0;                                 %���������� ����� �������

mu=[1,30,0.1,1];                       % �������� w-o-g-p
   %�      mu
mup=[0,  mu(1);
     0.002,20]; %�������� ��������
Ro=[1.04,0.95,0.00066,3,2.7]*1000;      % ��������� ����-�����-���-��������-�����
zc=[1e-6,1e-5,1e-3,1e-6,1e-6,1e-6]*0;     % ����������� ����-�����-���-��������-�����-����            
Bo=[1,1,0.5,1,1];                    % �������� ������������

%% ��������� �������
dh=0.0005;
Kc=1e+4;                                % ������������� �������

%% �������� ��������� 
lam=[0.65,0.13,0.06,0.5,0.8]*3600*24;    % ����. ����������������
Cp=[4.2,1.9,2.22,0.75,0.75]*1000;        % �����������
%Cp=[4.2,4.2,2.22,0.75,0.75]*1000;       % �����������


%% ������ � ���������
Z.Nl=Nl;
Z.as=as;
Z.aw=[aw,Swr,Sor];
Z.ts=ts;
Z.tw=[tw,SwrC,SorC];
Z.mu=mu;
Z.Ns=Ns;
Z.Ta=Ta;
Z.dt=dt;
Z.ndt=ndt;
Z.Ro=Ro;
Z.lam=lam;
Z.Cp=Cp;
Z.dh=dh;
Z.Kc=Kc;
Z.zc=zc;
Z.Bo=Bo;
Z.mup=mup;
Z.kms=kms;


%% ����������
syms Sw
SW=(Sw-Swr)./(1-Sor-Swr);
ko=(1-SW).^as(2);
kw=aw(1)*SW.^as(1);

gam=mu(1)/mu(2);

f=kw/(gam*ko+kw);
F=diff(f,Sw);

dS=Swr:0.001:(1-Sor);
fn=(subs(f,dS)-subs(f,0))./(dS-0);

fm=max(eval(fn));%
fn=eval(fn);
[r,c]=find(fm==fn);

Sc=dS(c);
Fc=eval(subs(F,Sc));

SW=(Sw-SwrC)./(1-SorC-SwrC);
kot=(1-SW).^ts(2);
kwt=tw(1)*SW.^ts(1);

f=kwt/(gam*kot+kwt);
F=diff(f,Sw);

ds=0.001;
dS=SwrC:ds:(1-SorC);
fn=(subs(f,dS)-subs(f,0))./(dS-0);
fm=max(eval(fn));%
fn=eval(fn);

[r,c]=find(fm==fn);
Sc2=dS(c(1));

if Sc2==ds
    Sc2=mu(1)/mu(2)*tw(2)/tw(1);
    Fc2=eval(subs(F,Sc2));
else
    Fc2=eval(subs(F,Sc2));
end;

Z.Fc=Fc;
Z.Fc2=Fc2;
Z.Sc2=Sc2;