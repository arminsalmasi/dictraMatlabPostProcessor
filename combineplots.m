clear variables; close all; clc;
%current_path= pwd ;  folder_name = uigetdir(current_path);
%folder_name = 'E:\Dropbox\KTH_PHD\Projects\GradientSintering\Results\1D-DICTRA-results-4-5-6-7-8-9-10-n2.5-TCFE-AIMD\10-labfact\10-1D-F20-DICTRA-TCFE8-AIMD-1mm-YAPFI2DGPsetup'
folder_name = 'E:\Dropbox\KTH_PHD\Projects\GradientSintering\Results\1D-DICTRA-results-4-5-6-7-8-9-10-n2.5-TCFE-AIMD\8-labfact\8-1D-F27-TCFE8-AIMD-1mm-70gp-105geo'
f(1) = openfig([folder_name '\pfs1.fig']);
f(2) = openfig([folder_name '\pfs2.fig']);
f(3) = openfig([folder_name '\pfs3.fig']);
handleLine = findobj(f,'type','line');


fig = figure
hold on ; box on;
movegui(gcf,'center')

fig.OuterPosition(1) =  fig.OuterPosition(1) -100
fig.OuterPosition(2) =  fig.OuterPosition(2) -100
fig.OuterPosition(3) =  fig.OuterPosition(3) +200
fig.OuterPosition(4) =  fig.OuterPosition(4) +200 


%fig.PaperPositionMode = 'auto';


for i = 1 : 2: length(handleLine)
    plot(get(handleLine(i),'XData'), get(handleLine(i),'YData')) ;
end
leg=legend({'$\beta$', '$\alpha$', '$\gamma$'},'Interpreter','latex');
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(fig, 'Type', 'Line'),'LineWidth',3);
set(ax,'fontsize',20);
xlabel('$Distance~(m)$','Interpreter','latex')
ylabel('$Phase ~ fractions$','Interpreter','latex')
xmax= 2e-4
xlim ([0 xmax]);
xticks([0:xmax/5:xmax])
savefig('uf.fig')
%print('ScreenSizeFigure','-dpng','-r0')


% % set all units inside figure to normalized so that everything is scaling accordingly
%  %set(findall(fig,'Units','pixels'),'Units','normalized');
%  % do not show figure on screen
%  %set(fig, 'visible', 'off')
%  % set figure units to pixels & adjust figure size
%  %fig.Units = 'pixels';
%  %fig.OuterPosition = [0 0 1000 1000];%7680 4320];
%  % define resolution figure to be saved in dpi
%  %res = 900;%;420;
%  % recalculate figure size to be saved
%  %set(fig,'PaperPositionMode','manual')
%  %fig.PaperUnits = 'inches';
%  %fig.PaperPosition = [0 0 7680 4320]/res;
%  % save figure
%  %print(fig,'TestFigure','-dpng',sprintf('-r%d',res))
%  %Sets the units of your root object (screen) to pixels
% set(0,'units','pixels')  
% %Obtains this pixel information
% Pix_SS = get(0,'screensize')
% 
% 
% 

%  