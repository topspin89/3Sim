clearvars

addpath('Sim_Lib','Tube_Lib','Gor_crack','Sparse_GPU','CrGeom','Termal_lib','GeoMeh_Lib',...
    'Well_lib','Crack_gen','Problems','Poly_lib','SS_lib','Diff_lib','Viz_lib','DATA_In','Adap_lib');
PR=Gl_PRM;

[KX,KY,KZ,Mp,P,Sw,Cp,T,NTG,WXY,H,Z,XY_GY,XY_GY_new]=Sintetic_Real(PR.Ns,PR.Nl);
%KX=10*KX;
%KX(:)=mean(KX(:));
XY_GYs=XY_GY;
%[KX,KY,KZ,Mp,P,Sw,Cp,T,NTG,WXY,H,Z]=Sintetic(PR.Ns,PR.Nl);
[WData]=Well_DATA(WXY,Z,PR.Ta);
%[WData,Ppwf,Pw_d,Pw_z]=Well_DATA_Adap(WXY,Z,PR.Ta);

[nt,PXY,gXY,PR.dl,tXY,XY_GY]=kvad_crack_fun(XY_GY,PR.Nl,WXY);
[DATA]=GridProp(KX,KY,KZ,Mp,P,Sw,Cp,T,NTG,WXY(:,:),H,Z,tXY,PR.Nl,WXY,XY_GY);
Sw0=DATA.gSw;
[GYData,DATA.gKX,DATA.gSw,B,A2B,dVb,pb]=GY_DATA(DATA,XY_GYs,XY_GY_new,PR);
B=[];
A2B(:,1:end)=[];
dVb=[];
pb=[];
%[WData.Doly,DATA.gKX,GYData.GY_Kxy]=Load_adp_prm2(WData.Doly,DATA.gKX,GYData.GY_Kxy);
%[WData.Doly,DATA,GYData]=Load_adp_prm(DATA,GYData,tXY);
%[nt1,PXY]=derevo(nt,DATA.XY,22);
%[nt,PXY]=elka(PR.Nl,DATA.XY,6,10,0,25);  % ���-�� ������, ������, ���� � ��������

[CrDATA]=CrackProp(DATA,PR,nt);
%[nt,PXY]=Tube_perc(PR,CrDATA,DATA.XY,1.1,WXY);

[gt,GS]=Tresh_Gor(1,DATA.XY,PR.Nl);

nt0={[]};
nt(:)={nt0};
[C,A2C,dVc,pc,DATA.WonV,DATA.Lc,CR_GRUP]=Conek2(DATA.XY,nt,PR.Nl,CrDATA,DATA.Won,WData.r0,DATA.ka);

gt(:)={[]};
%nt2(:)={[]};
[G,A2G,dVg,pg,DATA.WonG,DATA.Lg]=Conek(DATA.XY,gt,PR.Nl,CrDATA,DATA.Won,PR.dh,PR.Kc,WData.r0);%Gorizont(DATA.XY,GS,gt,WXY,WData.r0);

nd=DPorist(DATA.XY,PR.Nl);
% nd0={[]};
% nd(1:3)={nd0};
[D,A2D,dVd,pd,DATA.WonD,DATA.Ld,~,DATA.gMp,DATA.gMp_d]=Conek2D(DATA,nd,PR.Nl,CrDATA,WData);

[Pi,Sw,Ti,MCp,p,Q,Pw,PpW,SwC,NDT,Uf,dt1,dV0,DATA.ka,dtz]=SimT_MKT(PR,C,A2C,G,A2G,B,A2B,D,A2D,dVc,dVg,dVd,dVb,DATA,WData,GYData,1,CR_GRUP);

VZL(DATA,WXY,Pi,Sw(:,end),Ti,MCp,PR.Nl,p,Q,SwC,CR_GRUP,pc,nt,XY_GY,Uf(:,end),pb,GYData,XY_GY_new,dtz);
%VZL_VORONOI(XY,Sw(:,end),p,WXY,WData.Uf(:,end))


  Qo(:,1)=sum(Q(:,3,:));
  Ql(:,1)=sum(Q(:,2,:));
  Qz(:,1)=sum(Q(:,1,:));

 sQo=cumsum(Qo,1);
 sQl=cumsum(Ql,1);


c=1-Qo./Ql;
dV0([p,size(p,2)+pd])=dV0;
Sw0=Sw0(DATA.ka==1); Sw0=[Sw0;Sw0];
V0=sum(dV0.*(1-Sw0));
sQo(end,:)/V0