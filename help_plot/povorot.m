% alfa=pi/2*0;
% X0=[750;500;250];
% Y0=[500;750;500];
% X1=X0+100*sin(alfa);
% Y1=Y0-100*cos(alfa);

% SD=load('WHor.mat');
% for i=1:size(SD.WHO100,2)
%     WXY=SD.WHO100_90{i};
%     plot(WXY(:,1),WXY(:,2),'*')
%     hold on
% end

% i=0;
% alfa=pi/2*0;
% X0=[750;500;250];
% Y0=[500;750;500];
% for alfa=[0,pi/6,pi/4,pi/3,pi/2]
% i=i+1;    
% X1=X0+100*sin(alfa+pi/2);
% Y1=Y0-100*cos(alfa+pi/2);
% XY=WHO100{i};
% XY([4,6,8],:)=[X1,Y1];
% WHO100(i)={XY};
% end