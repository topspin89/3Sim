function VZL_VORONOI_vid_crack(DATA,Sw,p,WXY,uf,Nl,NT,SwC,CR_GRUP,XY,z,A2C)
xy=DATA.XY;
BND=DATA.BND;
ka=DATA.ka;

writerObj = VideoWriter('Pre_new.avi','MPEG-4');
open(writerObj);

[V,C,I]=VoronoiLimit(xy(:,1),xy(:,2),BND); 
%  DT=delaunayTriangulation(xy(:,1),xy(:,2),BND);
%      IO = isInterior(DT);
%      FG=DT.ConnectivityList(IO,:);
%      TR=triangulation(FG,xy(:,1),xy(:,2));
%      
% [V,C] = voronoiDiagram(TR);
%[V,C]=voronoin(xy); 
Sw0=zeros(size(ka,1),size(Sw,2));
Sw1=Sw(1:size(p,2),:);
Sw0(ka==1,:)=Sw1;
Sw0(ka==0,:)=nan;
Sw0(p,:)=Sw0(:,:);
Sw0=Sw0(I,:);
figure1=figure('Position',[10 10 1776 900]);

dx=max(xy(:,1))-min(xy(:,1));
dy=max(xy(:,2))-min(xy(:,2));
asx=dx/dy;

axes1 = axes('Parent',figure1,'PlotBoxAspectRatio',[asx 1 1],'CLim',[0.25 0.75]);
set(axes1,'PlotBoxAspectRatio',[asx 1 1])
hold(axes1,'all');
axis off

for i=1:size(BND,1)
 hh=figure1;
 plot(xy(BND(i,:),1),xy(BND(i,:),2),'Color',[0 0 0]);  
 pause(0.001)
 if mod(i,10)==0
 frame = getframe(hh);
 writeVideo(writerObj,frame);
 end
end
    
for i=1:size(WXY,1)/2
    
    plot(WXY(i,1),WXY(i,2),'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5],...
    'MarkerSize',2,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 1])
    plot(WXY(i+1,1),WXY(i+1,2),'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5],...
    'MarkerSize',2,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 1])
    pause(0.001)
    if mod(i,10)==0
    hh=figure1;
    frame = getframe(hh);
    writeVideo(writerObj,frame);
    end
end

plot(xy(:,1),xy(:,2),'.','Color',[0.301960796117783 0.745098054409027 0.933333337306976])
plot(WXY(:,1),WXY(:,2),'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5],...
    'MarkerSize',2.5,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 1])
pause(0.1)
    hh=figure1;
    frame = getframe(hh);
    writeVideo(writerObj,frame);
DT=delaunayTriangulation(xy(:,1),xy(:,2),BND);
 IO = isInterior(DT);
 FG=DT.ConnectivityList(IO,:);
 TR=triangulation(FG,xy(:,1),xy(:,2));
h1=triplot(TR,'Color',[0.301960796117783 0.745098054409027 0.933333337306976]);
    hh=figure1;
    frame = getframe(hh);
    writeVideo(writerObj,frame);
% axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on',...
%     'Position',[0.13 0.11 0.651609195402299 0.815],...
%     'FontSize',14);

for k=1:length(C)
    
    VertCell = V(C{k},:);
    ZZ=0*ones(size(VertCell(:,1)));
    hp=patch(VertCell(:,1),VertCell(:,2),ZZ,Sw0(k,1),'FaceColor','flat');
    HP(k)={hp};
    if mod(k,100)==0
        hh=figure1;
        frame = getframe(hh);
        writeVideo(writerObj,frame);
        pause(0.01)
    end
end
plot(WXY(uf==-1,1),WXY(uf==-1,2),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',2,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 1]);
plot(WXY(uf==1,1),WXY(uf==1,2),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',2,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 0 0]);

set(h1,'Visible','off')
%set(gca,'CLim',[0 1])
plot_crack_color(Nl,NT,SwC,CR_GRUP,XY,z,A2C)

for t=1:size(Sw0,2)
    for k=1:length(C)
        
        VertCell = V(C{k},:);
        ZZ=0*ones(size(VertCell(:,1)));
        set(HP{k},'CData',Sw0(k,t));%'FaceColor',[1-Sw0(k,t),Sw0(k,t),Sw0(k,t)])
        %hp=patch(VertCell(:,1),VertCell(:,2),ZZ,Sw0(k,t),'FaceColor','flat');
        %HP(k)={hp};
    end
    
    hh=figure1;
    frame = getframe(hh);
    writeVideo(writerObj,frame);
end
    
plot(WXY(uf==-1,1),WXY(uf==-1,2),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',2,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 1]);
plot(WXY(uf==1,1),WXY(uf==1,2),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',2,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 0 0]);
hold off

    hh=figure1;
    frame = getframe(hh);
    writeVideo(writerObj,frame);

% for j=1:size(hh,2)
%     frame(j) = getframe(hh(j));
% writeVideo(writerObj,frame(j));
% end;
close(writerObj);
end
function plot_crack_color(Nl,NT,SwC,CR_GRUP,XY,z,A2C)

if Nl==1
    for i1=1:size(NT,2)
        nt=NT{i1};
        SwC_nC=SwC(CR_GRUP==i1);
        unt=unique(nt);
        for i=1:size(nt,2)
            rr1=find(nt(1,i)==unt);
            rr2=find(nt(2,i)==unt);
            col_sw=(SwC_nC(rr1)+SwC_nC(rr2))/2;
            col_sw=((1-col_sw)*0.9+0.1);
            vx=[XY(nt(1,i),1),XY(nt(2,i),1)];
            vy=[XY(nt(1,i),2),XY(nt(2,i),2)];
            plot(vx,vy,'Color',[col_sw col_sw col_sw])
            
            hold on
        end;
    end;
else
    for i2=1:size(NT,2)
        nt=NT{i2};
        unt=unique(nt);
        sw=SwC(i2==CR_GRUP(:,1));
        a2c=A2C(:,i2==CR_GRUP(:,1));
        [r,c]=find(a2c);
    
        vxy=XY(r,:);
        vz=z(r);
        fz=zeros(size(z));
        fz(r)=1;
        [~,c1]=find(fz);
        na=size(sw,1);

        nl=max(c1)-min(c1)+1;
        vx=reshape(vxy(:,1),na/nl,nl);
        vy=reshape(vxy(:,2),na/nl,nl);
        vz1=reshape(vz,na/nl,nl);
        sw1=reshape(sw,na/nl,nl);
        surf(vx,vy,vz1,sw1,'LineStyle','none');
        %plot3(vx,vy,vz,'Color',[col_sw col_sw col_sw])
        hold on
    end;
end;
end