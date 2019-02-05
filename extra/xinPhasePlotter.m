%% plot time steps
plotter(tstps,folder_name);

%% function plotter
function [] = plotter(tstps,folder_name)
  load([folder_name '\postDataTmp.mat'], 'TIME');
  for i = 1 : size(tstps,2)
    fname= ['fs_t_' num2str(TIME(tstps(i)),'%10.0f') '.mat'];
    load([folder_name '\' fname],'dist','tstp','timeToPlot',...
        'nel','nph','elnames','phnamesPLOT',...
        'xinPhase');
    XinPhase(i,:,:,:)= xinPhase;
    dstf(:,i)=dist;
    clear xinPhase,
  end
%% Prompt to read file prefix
    prompt = 'file name prefix:'
    fNamesPrefix = input(prompt,'s')
%% Prompt to read xlimits    
    prompt = 'Xlow:'
    Xlow = input(prompt)
    prompt = 'Xmax:'
    Xmax = input(prompt) 
%% Plot mole fraction of elemnts in phases   
  for j = 1 : size(tstps,2)   
    for i = 1 :nph
      TF = contains(phnamesPLOT(i),'ZZDICTRA-GHOST','IgnoreCase',true);
      if ~TF 
        figure
        hold on  
        for k= 1: nel
          xinphaseTemp(1,:)=XinPhase(j,i,k,:);
          plot(dstf(:,j), xinphaseTemp(1,:));
          legendcell(k)=cellstr(['X(' elnames{k} ',' phnamesPLOT{i} ')']);
        end
        xlabel('Distance [m]','FontSize',15); %'Interpreter','latex'
        ylabel(['Mole-Fraction of elements in the phase' ],'FontSize',15); %'Interpreter','latex',
        leg=legend(legendcell,'FontSize',15);
        title( ['time: ' num2str(TIME(tstps(j))) ' sec' ] );      
        choice = questdlg('Save the timestep plot to file?','save to file','.fig', '.png', 'NO', 'No');
        switch choice
          case '.fig'
            saveas(gcf,[folder_name '\'  fNamesPrefix 'xinPh_' num2str(i) '.fig'])
          case '.png'
            saveas(gcf,[folder_name '\'  fNamesPrefix 'xinPh_' num2str(i) '.png'])
        end %case
      end
    end
    
  end 
end
