function SD=main_par_Z(fl,fl1,fl2,fl3)

addpath('Sim_Lib','Tube_Lib','Gor_crack','Sparse_GPU','CrGeom','Termal_lib','GeoMeh_Lib',...
    'Well_lib','Crack_gen','Problems','Poly_lib','SS_lib','Diff_lib','Viz_lib','DATA_In','Adap_lib');
PR=Gl_PRM;%imp_glb_prm;%
if fl3==9
    PR.Ta=300*365;
end
[KX,KY,KZ,Mp,P,Sw,Cp,T,NTG,WXY,H,Z,XY_GY,XY_GY_new,GY_subl]=Sintetic_Real(PR.Ns,PR.Nl,fl2);

if fl==1
sD=load('dK16_10');
KX=sD.dK.*KX;
KY=sD.dK.*KY;
KZ=sD.dK.*KZ;
end

KZ0=KZ;
kz(1)={KZ0};
%KZ(:,1:8:end)=KZ(:,1:8:end)*0.01; kz(2)={KZ};
KZ(:,1:4:end)=KZ0(:,1:4:end)*0.01; kz(2)={KZ};
KZ(:,1:2:end)=KZ0(:,1:2:end)*0.01; kz(3)={KZ};
KZ(:,1:1:end)=KZ0(:,1:1:end)*0.01; kz(4)={KZ};

parfor i=1:4
    SD(i)=par_run(KX,KY,kz{i},Mp,P,Sw,Cp,T,NTG,WXY,H,Z,XY_GY,XY_GY_new,GY_subl,PR,fl1,fl3,i);
end
end

function SD=par_run(KX,KY,KZ,Mp,P,Sw,Cp,T,NTG,WXY,H,Z,XY_GY,XY_GY_new,GY_subl,PR,fl1,fl3,i)

[WData,Won3,~]=Well_DATA(WXY,Z,PR.Ta,PR.Nl,PR.drob,fl3);
%[WData,Ppwf,Pw_d,Pw_z]=Well_DATA_Adap(WXY,Z,PR.Ta);
% if i==4
% WData.Pw(1:4,:)=10*WData.Pw(1:4,:);
% elseif i==5
%     WData.Pw(1:4,:)=75*WData.Pw(1:4,:);
% end
[nt,gXY,PR.dl,tXY,XY_GY,Won3,WData]=kvad_crack_fun(XY_GY,PR.Nl,WData,PR.drob,Won3);
%[nt,PXY,gXY,PR.dl,tXY,XY_GY1,Won3,WData]=kvad_crack_fun1(XY_GY,PR.Nl,WData,PR.drob,Won3,SD.g_cr_90);
[DATA]=GridProp(KX,KY,KZ,Mp,P,Sw,Cp,T,NTG,WXY(:,:),H,Z,tXY,PR.Nl,WData.WXY,XY_GY,GY_subl,Won3);
Sw0=DATA.gSw;
[GYData,DATA.gKX,DATA.gSw,B,A2B,dVb,pb]=GY_DATA(0,DATA,XY_GY_new,PR); %0/1 - ����/���. �������

if fl1==0
nt={zeros(2,0)};
end
%nt=elka(1,PR.Nl,DATA.XY,3,30,0,25);  %0/1 - ����/���.; ���-�� ������, ������, ���� � ��������
%load('nt_s2')
[CrDATA]=CrackProp(DATA,PR,nt);
%[nt,PXY]=Tube_perc(PR,CrDATA,DATA.XY,1.1,WXY);
[C,A2C,dVc,pc,DATA.WonV,DATA.Lc,CR_GRUP]=Conek2(DATA.XY,DATA.gZ,nt,PR.Nl,CrDATA,DATA.Won,WData.r0,DATA.ka);

gt=Tresh_Gor(PR.fC(2),DATA.XY,PR.Nl);  % 0/1 - ����/���. �������������� ����.
[GData]=Conek2G(DATA,gt,PR.Nl,CrDATA,WData);

nd=DPorist(PR.fC(3),DATA.XY,PR.Nl); % 0/1 - ����/���. ������� ����������
[DData,~,DATA.gMp]=Conek2D(DATA,nd,PR.Nl,CrDATA,WData,A2C,GData.A2G,PR.ddol);

[Pi,Sw,Ti,MCp,p,Q,Pw,PpW,SwC,NDT,Uf,dt1,dV0,DATA.ka,dtz,DSw]=SimT_MKT(PR,C,A2C,GData,B,A2B,DData,dVc,dVb,DATA,WData,GYData,1,CR_GRUP);
i
VZL(DATA,WData.WXY,Pi,Sw(:,end),Ti,MCp,PR.Nl,p,Q,SwC,CR_GRUP,pc,nt,XY_GY,Uf(:,end),pb,GYData,XY_GY_new,dtz,Won3,A2C);
%VZL_VORONOI(DATA,Pi(:,end),p,WXY,WData.Uf(:,end))

  Qo(:,1)=sum(Q(:,3,:));
  Ql(:,1)=sum(Q(:,2,:));
  Qz(:,1)=sum(Q(:,1,:));

 sQo=cumsum(Qo,1);
 sQl=cumsum(Ql,1);

c=1-Qo./Ql;
%plot(c)
dV1([p,size(p,2)+DData.pd])=dV0([1:size(p,2),size(p,2)+size(pc,2)+1:size(pc,2)+size(p,2)+size(DData.pd,2)]);
Sw0=Sw0(DATA.ka==1); Sw0=[Sw0;Sw0(1:size(DData.D,1))];
V0=sum(dV1'.*(1-Sw0));
sQo(end,:)/V0;
SD={[c,sQo,sQl,sQo/(500*500*40*0.3*0.75),Qo,Ql]};
end