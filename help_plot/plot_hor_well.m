XY1=[0,0;500,0;500,500;0,500];
plot(XY1(:,1),XY1(:,2),'.')
hold on 
plot([250;250],[250,150])

% g_cr{1,1}=[220,400;
%            220,100]; %����
% 
% g_cr{2,1}=[180,400;
%            180,100]; %����
%        
% g_cr{3,1}=[280,400;
%            280,100]; %����
%        
% g_cr{4,1}=[320,400;
%            320,100]; %����
% 
% % g_cr{5,1}=[280,200;
% %            450,200]; %����
% %        
% % g_cr{6,1}=[280,230;
% %            450,230]; %����
% 
% for i=1:size(g_cr,1)
%    XY=g_cr{i,:};
%    plot(XY(:,1),XY(:,2))
%    hold on 
% end
for i=7
    g_cr=GF{i};
    subplot(1,3,i-6),
    XY1=[0,0;500,0;500,500;0,500];
    plot(XY1(:,1),XY1(:,2),'o')
    hold on
    plot([250;250],[250,150])
    plot(250,250,'o')
    grid on
    xlim([0 500])
    ylim([0 500])
    for j=1:size(g_cr,1)
        XY=g_cr{j,:};
        plot(XY(:,1),XY(:,2))
        hold on
    end
end