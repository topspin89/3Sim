function Z=imp_glb_prm
%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\Lik2\Documents\MATLAB\3Sim\2be_0.67\Gl_prm.txt
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2014/12/02 17:23:42

%% Initialize variables.
filename = '2exe\Gl_prm.txt';
delimiter = {';','='};

%% Format string for each line of text:
%   column1: text (%s)
%	column2: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Glprm = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

Let(1)={'Nl'};     Let(2)={'as'};    Let(3)={'aw'};
Let(4)={'ts'};     Let(5)={'tw'};    Let(6)={'mu'};
Let(7)={'Ns'};     Let(8)={'T'};    Let(9)={'dt'};

Let(10)={'ndt'};   Let(11)={'Ro'};   Let(12)={'lam'};
Let(13)={'Cp'};    Let(14)={'dh'};   Let(15)={'hg'};
Let(16)={'Kc'};    Let(17)={'Kg'};   Let(18)={'Kd'};

Let(19)={'zc'};    Let(20)={'Bo'};    Let(21)={'mup'};
Let(22)={'kms'};   Let(23)={'Fc'};    Let(24)={'Sc'};
Let(25)={'Fc2'};   Let(26)={'Sc2'};   Let(27)={'Swr'};
Let(28)={'Sor'};   Let(29)={'SwrC'};   Let(30)={'SorC'};

for i=1:30
 a=strcmp(Let(i),Glprm(:,1));
 if sum(a)>0
 DTA(i,1)={str2num(Glprm{a==1,2})};
 end
end;

Z.Nl=DTA{1};
Z.as=DTA{2};
Z.aw=[DTA{3},DTA{27},DTA{28}];
Z.ts=DTA{4};
Z.tw=[DTA{5},DTA{29},DTA{30}];
Z.mu=DTA{6};
Z.Ns=DTA{7};
Z.Ta=DTA{8};
Z.dt=DTA{9};
Z.ndt=DTA{10};
Z.Ro=DTA{11};
Z.lam=DTA{12};
Z.Cp=DTA{13};
Z.dh=DTA{14};
Z.Hg=DTA{15};
Z.Kc=DTA{16};
Z.Kg=DTA{17};
Z.Kd=DTA{18};
Z.zc=DTA{19};
Z.Bo=DTA{20};
mup=DTA{21};
mup(2)=DTA{7}(1);
Z.mup=[mup(1:2);mup(3:4)];
Z.kms=DTA{22};

[Z.Fc,Z.Sc]=sum2bol(Z.aw,Z.as);
[Z.Fc2,Z.Sc2]=sum2bol(Z.tw,Z.ts);
end
function [Sc,Fc]=sum2bol(AW,as)
Swr=AW(4);
Sor=AW(5);
aw=AW(1:3);

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
end