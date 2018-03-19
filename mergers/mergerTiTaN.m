close all
clear all
clc
%% Load saved figures
f(1)=hgload('data\13-3mm-1e-3-mfs_Ti.fig');
f(2)=hgload('data\14-3mm-1e-3-mfs_Ti.fig');
f(3)=hgload('data\15-3mm-1e-3-mfs_Ti.fig');
f(4)=hgload('data\16-3mm-1e-3-mfs_Ti.fig');
f(5)=hgload('data\null.fig');
f(6)=hgload('data\18-3mm-1e-3-mfs_TI.fig');

f(7)=hgload('data\null.fig');
f(8)=hgload('data\14-3mm-1e-3-mfs_Ta.fig');
f(9)=hgload('data\15-3mm-1e-3-mfs_Ta.fig');
f(10)=hgload('data\16-3mm-1e-3-mfs_Ta.fig');
f(11)=hgload('data\17-3mm-1e-3-mfs_Ta.fig');
f(12)=hgload('data\18-3mm-1e-3-mfs_Ta.fig');

f(13)=hgload('data\13-3mm-1e-3-mfs_n.fig');
f(14)=hgload('data\14-3mm-1e-3-mfs_n.fig');
f(15)=hgload('data\15-3mm-1e-3-mfs_n.fig');
f(16)=hgload('data\16-3mm-1e-3-mfs_n.fig');
f(17)=hgload('data\17-3mm-1e-3-mfs_n.fig');
f(18)=hgload('data\18-3mm-1e-3-mfs_n.fig');

%% Prepare subplots
h0 = figure('units','normalized','outerposition',[0 0 1 1]);
for i =1 : 18
  h(i)=subplot(3,6,i);
box on
end

%% Paste figures on the subplots
for i = 1: 18
copyobj(allchild(get(f(i),'CurrentAxes')),h(i));
end

%% Add legends
% for i = [1:4,6,8:18]
% l(i)=legend(h(i),'t=0','t=5300','Location','northwest');
% end 

%% set subtitle
suptitle('Mole fractions of elements Ti Ta N | time(0,5300) | BC: AC(N,Gas)=1e-3 | AC(C,graph)=0.5 at 1450 C');
set(findall(h, 'Type', 'Line'),'LineWidth',1.5);

h(1).Title.String=({'X(Ta)=0 X(Ti)=3e-2 X(N)=4e-3',        'X(Ti)'});
h(2).Title.String=({'X(Ta)=1e-2 X(Ti)=2e-2 X(N)=4e-3',     'X(Ti)'});
h(3).Title.String=({'X(Ta)=1.5e-2 X(Ti)=1.5e-2 X(N)=4e-3', 'X(Ti)'});
h(4).Title.String=({'X(Ta)=2e-2 X(Ti)=1e-2 X(N)=4e-3',     'X(Ti)'});
h(5).Title.String=({'X(Ta)=3e-2 X(Ti)=0 X(N)=4e-3',        'X(Ti)'});
h(6).Title.String=({'X(Ta)=1.5e-2 X(Ti)=3e-2 X(N)=4e-3',   'X(Ti)'});

for i = 7 : 12
h(i).Title.String=({'X(Ta)'});
end

for i = 13 : 18
h(i).Title.String=({'X(N)'});
end

%% Limits on X and Y
for i = 1 : 18
  h(i).XLim=[0,30e-4];
end

%% Arrow
X = [0.1 0.1];
Y = [0.6   0.4];
anot= annotation('arrow',X,Y,'Color','red');
anot.LineWidth=6;

%% save fig
fig = gcf;
fig.PaperPositionMode = 'auto';
print('XTiTaN-30e-4m','-dpng','-r0');


