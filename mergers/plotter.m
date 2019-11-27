
function [] = plotter(fname, folder_name)

load(fname ,'mfs','dist','timeToPlot','nel','elnames');
load ([ folder_name '\TIME.TXT']);
mf(1,:,:)=mfs;%
dstf(:,1)=dist; %
tmToPlotf(1)=timeToPlot;%
clear  mfs  dist timeToPlot

%% Plot individual mole fractions
    mftemp(:,:) = mf(1,:,:);
    mftempp = mftemp(1,:)
    plot(dstf(:), mftempp(:));
    

end


% legendcell(j)=cellstr(['exp= ' num2str(num)]);
% xlabel('Distance [m]','FontSize',15); %'Interpreter','latex'
% ylabel(['Mole-Fraction ' elnames{i}],'FontSize',15); %'Interpreter','latex',
% leg=legend(legendcell,'FontSize',15);