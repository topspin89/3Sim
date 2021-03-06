function [C,A2C,dVc,p,WonV,L,CR_GRUP]=Conek2(XY,Z,NLT,Nl,CrDATA,Won,r0,ka)

np=size(XY,1);
%Z=ones(np,1);
HH=CrDATA.H;
dC=CrDATA.dC;
KC=CrDATA.KC;
DH=CrDATA.DH;
alp_C=CrDATA.alp_C;

WonV=zeros(0,3);

k=0;

[AA]=MR_Prop(XY,Nl);
mnt=size(NLT,2);
dV_L=cell(mnt,1);
C_L=cell(mnt,1);
L_L=cell(mnt,1);
A2C_L=cell(mnt,1);
CR_grup=cell(mnt,1);
snt=0;
for i=1:mnt
    nt=NLT{i};  % ������ ����� � ���������
    kc=KC{i};   % ������������� �������
    dh=DH{i};   % ����������� �������
    [L,~,~,H]=Geome3_1(AA,XY,Z,HH);
    na=size(L,1);
    A=sparse(nt(2,:),nt(1,:),1,na,na);

    A=A+A';
    %        figure(235),spy(A)
    unt=unique(nt);
    
    A1=A(unt,:);   A2=A1(:,unt);
    L1=L(unt,:);   L2=L1(:,unt);
    H1=H(unt,:);   H2=H1(:,unt);
    
    for j=1:size(Won,1)
        ty=find(Won(j,1)==unt);
        if isempty(ty)==0
            k=k+1;
            WonV(k,1)=ty(1)+snt;
            WonV(k,2)=HH(Won(j,1))*dh(i)*kc*8.64/r0;%dC*100;
            WonV(k,3)=Won(j,3);
        end;
    end;
    snt=snt+size(unt,1);
    %         WonV
    n=size(A2,1);
    [r,c]=find(A2==1);
    C=H2(r+(c-1)*n)*dh(i)./L2(r+(c-1)*n)*kc*8.34;
    C=sparse(r,c,C,n,n);
    
    a2c=sum(H2.*L2,2)*alp_C;
    A2C=sparse(unt,1:n,a2c,np*Nl,n);
    dVc=sum(H2.*L2.*dh(i),2);
    dV_L(i)={dVc};
    C_L(i)={C};
    L_L(i)={L};
    A2C_L(i)={A2C};
    CR_grup(i)={i*ones(size(C,1),1)};
end;

C_cell=Mat_Constr(C_L);
L_cell=Mat_Constr(L_L);
A2C=cell2mat(A2C_L');
dVc=cell2mat(dV_L);
CR_GRUP=cell2mat(CR_grup);
C=cell2mat(C_cell);
L=cell2mat(L_cell);

p=symrcm(C);
C=C(p,p);
L=L(p,p);
A2C=A2C(:,p);
A2C=A2C(ka==1,:);
dVc=dVc(p);
CR_GRUP=CR_GRUP(p,:);
for i=1:size(WonV,1)
    WonV(i,1)=find(WonV(i,1)==p);
end;
end

function C=Mat_Constr(c)
n=size(c,1);
cb=cell(n,n);
for i=1:n
    A=c{i};
    ni=size(A,1);
    for j=1:n
        mj=size(c{j},2);
        cb(i,j)={sparse(ni,mj)};
    end;
    cb(i,i)=c(i);
end;

C=cell2mat(cb);
C={C};
end