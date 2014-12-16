function [NLT,PXY,gXY,dl,tXY,XY_GY]=kvad_crack_fun(XY_GY,NL,WXY)
%dh=16;
dh=10;

rad=6.5*dh*0.5;         % ������ ������� ������ ��������
drob=6.5*dh;        % ������� �����
dl=6.5*dh;          % ��� �������
dl2=6.5*dh*0.5;         % ������� ������ �������

ws=size(WXY,1);
NT=cell(NL,1);
PXY=cell(NL,1);

g_cr{1,1}=[];
   % Nt l    X  Y
g_cr{1,1}=[0,0;
           400,400]; %����

%g_cr{2,1}=[220,210;
%           100,120]; %����
       
%g_cr{1,2}=[110,110;
%           140,170]; %����

ImA=zeros(size(g_cr,1),NL);

if isempty(g_cr{1,1})==0; 
    [p,GR] = Mesh3(XY_GY,drob);
%plot(p(:,1),p(:,2),'*')
    for i=1:size(g_cr,1)
        for j=1:size(g_cr,2)
            A=g_cr{i,j};
            ImA(i,j)=(isempty(A)==0);
        end;
    end;

    [r,c]=find(ImA);
    for i=1:size(r,1)
        gcr(i,1)=g_cr(r(i),c(i));
    end;

     
    [crk2] = Fracture(gcr,dl);
    [pm2] = Purgatory(p,crk2,dl2,WXY,rad);
    cr=cell2mat(crk2);

    for i=1:size(r,1)
       crk(r(i),c(i))=crk2(i);
    end;

    [IN,ON]=inpolygon(p(:,1),p(:,2),XY_GY(:,1),XY_GY(:,2));
    gXY=[cr;pm2;p(ON==1,:)];
    gXY=NODuble2(gXY);
    XY_GY=p(ON==1,:);
    sr=[];
    for j=1:ws
        rr=find((WXY(j,1)==gXY(:,1)).*(WXY(j,2)==gXY(:,2))==1);
        sr=[sr;rr];
    end;
    
    if isempty(sr)==0
        gXY(sr,:)=[];
    end;
     tXY=[WXY;gXY];

for l=1:NL
rl=find(ImA(:,l)); 
  for i=rl' 
     cr=crk{i,l};
     nt=[];
      for j=1:size(cr,1)
       a1=(cr(j,1)==tXY(:,1)).*(cr(j,2)==tXY(:,2));
       nt(j)=find(a1==1);
      end;
     nt1=nt(1:end-1);
     nt2=nt(2:end);
     Nt(i)={[nt1;nt2]};
  end;
NLT(l)={Nt};
Nt={[]};
end;

   
for l=1:NL
rl=find(ImA(:,l));  
  for i=rl' 
   crn=crk{i,l};
   x1=crn(1:end-1,1);
   x2=crn(2:end,1);
   y1=crn(1:end-1,2);
   y2=crn(2:end,2);
            
   pxy(1,i)={[x1,x2]};
   pxy(2,i)={[y1,y2]};
  end;
PXY(l)={pxy};
pxy={[]};
end;

else
    
   [p,GR] = Mesh4(WXY,drob); 
   NLT=cell(Nl,1);
   PXY=[];
   gXY=p;
   tXY=[WXY;gXY];
end;
   
end

function XY=NODuble(XY)
i=0;
while i<size(XY,2)
    i=i+1;
    a1=XY(i)==XY;
    if sum(a1)>1
     r=find(a1);
     XY(r(2:end))=[];
    end;
end;
end


function XY=NODuble2(XY)
i=0;
while i<size(XY,1)
    i=i+1;
    a1=(XY(i,1)==XY(:,1)).*(XY(i,2)==XY(:,2));
    if sum(a1)>1
     r=find(a1);
     XY(r(2:end),:)=[];
    end;
end;
end