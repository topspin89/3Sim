function nt=elka(on,Nl,gXY,kol,dlin,wfl,ii)
 nt=cell(Nl,1);
 
if on==1
    PXY=cell(Nl,1);
       
    for l=1:Nl
        [A]=MR_Prop(gXY,1);
        na=size(gXY,1);
        
        A=A.*(A>0);
        %A(:,Nt)=0;
        x3=[];
        y3=[];
        x1=gXY(:,1);
        y1=gXY(:,2);
        figure(ii+l),plot(min(gXY(:,1)),min(gXY(:,2)),max(gXY(:,1)),max(gXY(:,2)));
        hold on
        new_nt=cell(1,kol);
        for i=1:kol
            k=0;
            fl1=1;
            while fl1==1 && k<20
                k=k+1;
                if i==1;
                    ni=5;
                else
                ni=randi(na,1);
                end
                
                if sum(ni==cell2mat(new_nt))==0
                    fl1=0;
                end;
            end;
            
            new(1,1)=ni;
            A(ni,:)=0;
            nt1=[];
            nt2=[];
            for j=1:dlin
                r=find(A(:,ni));
                if isempty(r)==0
                    %kv=randi(3,1);
                    % mk=min([max(kv),numel(r)]);
                    xr=rand(1);
                    mk=2*(xr>0.6)+(xr<=0.6);
                    nj=randi(numel(r),mk,1);
                    A(r(nj),:)=0;
                    
                    x2=x1(ni)*ones(1,mk);
                    y2=y1(ni)*ones(1,mk);
                    
                    
                    plot([x2;x1(r(nj))'],[y2;y1(r(nj))']);
                    ni0=ni;
                    ni=r(nj(1));
                    
                    x3=[x3;[x2',x1(r(nj))]];
                    y3=[y3;[y2',y1(r(nj))]];
                    
                    %                 new=[new,r(nj)'];
                    
                    nt1=[nt1,ni0*ones(1,size(nj,1))];
                    nt2=[nt2,r(nj)'];
                end;
            end;
            new=[nt1;nt2];
            %new=NODuble(new);
            new_nt(i)={new};
            
            pxy(1,i)={x3};
            pxy(2,i)={y3};
        end;
        
        %new_nt=[new_nt,new];
        
        nt(l)={new_nt};
        PXY(l)={pxy};
        
    end;
    
    for l=1:Nl
        NT=nt{l};
        pxy=PXY{l};
        j=0;
        de=[];
        for i=1:size(NT,2)
            nnt=NT{i};
            if numel(nnt)<2
                j=j+1;
                de(j)=i;
            end;
        end;
        NT(de)=[];
        pxy(:,de)=[];
        
        nt(l)={NT};
        PXY(l)={pxy};
    end;
    
    
    hold off
else
    
    nt0={[]};
    nt(:)={nt0};
end
end
%

%
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