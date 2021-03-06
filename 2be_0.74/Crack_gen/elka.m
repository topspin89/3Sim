function nt=elka(on,Nl,gXY,kol,dlin,wfl,ii,Z,fl_con)
 
if on==1
 nt=cell(1,kol);
 [A]=MR_Prop(gXY,1);
        A=A.*(A>0);
    for i=1:kol
        
        na=size(gXY,1);
 
        %A(:,Nt)=0;
        x3=[];
        y3=[];
        x1=gXY(:,1);
        y1=gXY(:,2);
        figure(ii),plot(min(gXY(:,1)),min(gXY(:,2)),max(gXY(:,1)),max(gXY(:,2)));
        hold on
              
        k=0;
        fl1=1;
        while fl1==1 && k<20
            k=k+1;
            if i==1 %|| i==2
                ni=5;
            else
                in=inpolygon(gXY(:,1),gXY(:,2),[150;350;350;150;150],[150;150;350;350;150]);
                %ni=randi(na,1);
                ni=randi(sum(in),1);
                r=find(in);
                ni=r(ni);
            end
            
            if sum(ni==cell2mat(nt))==0
                fl1=0;
            end;
        end;
        
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
                
                nt1=[nt1,ni0*ones(1,size(nj,1))];
                nt2=[nt2,r(nj)'];
            end;
        end;

        z(1)=min(Z).*(min(Z)<=Nl)+Nl*(min(Z)>Nl);
        z(2)=max(Z).*(max(Z)<=Nl)+Nl*(max(Z)>Nl);
        Z_nt1=[];
        Z_nt2=[];
        nl=size(nt1,2);
        k1=0;
        for j=z(1):z(2)
            k1=k1+1;
            Z_nt1=[Z_nt1,nt1+(j-1)*na];
            Z_nt2=[Z_nt2,nt2+(j-1)*na];
        end
        if z(1)~=z(2)
            Z_nt1=[Z_nt1,Z_nt1(1:nl*(k-1))];
            Z_nt2=[Z_nt2,Z_nt1(nl+1:nl*k)];
        end
        nt(i)={[Z_nt1;Z_nt2]};

   end;
    
        j=0;
        de=[];
        for i=1:size(nt,2)
            nnt=nt{i};
            if numel(nnt)<2
                j=j+1;
                de(j)=i;
            end;
        end;
        nt(de)=[];
      nt=is_con(nt,fl_con,gXY);    
    hold off
else
    
    nt(:)={[]};
end
end

function nt=is_con(nt0,fl_con,XY)
 if fl_con~=0
 [A]=MR_Prop(XY,1);
 A=A.*(A>0);
  for i=1:size(nt0,2)
     nc=unique(nt0{i}); 
     A1=A(nc,:);
     [r,c]=find(A1);
     nvc(i)={unique(c)}; 
  end
  ij=0;
  for i=1:size(nt0,2)
      for j=1:size(nt0,2)
       if i~=j   
        [C,ia,ib]=intersect(nvc{i},nvc{j});
        if numel(C)>0
            ri=randi(numel(C),1);
            C=C(ri);
            [r,c]=find(A(C,:));
            for k=1:size(unique(r),1)
                c1=c(r==r(k));
                [C1,ia1,ib1]=intersect(c1,nt0{i});
                [C2,ia2,ib2]=intersect(c1,nt0{j});
                M(:,k*2-1:k*2)=[C1(1),C;C,C2(1)];
            end
            ij=ij+1;
            nt(ij)={[nt0{i},[M],nt0{j}]};
        end
       end
      end
  end
  nt={unique(cell2mat(nt)','rows')'};
 end
end