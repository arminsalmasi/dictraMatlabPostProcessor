%% plot time steps
plotter(tstps,folder_name);

%% function plotter
function [] = plotter(tstps,folder_name)
load([folder_name '\postDataTmp.mat'], 'TIME');
for i = 1 : size(tstps,2)
  fname= ['fs_t_' num2str(TIME(tstps(i)),'%10.0f') '.mat'];
  load([folder_name '\' fname],...
        'wfs', 'mfs', 'pfs','chemps','dist','tstp',...
        'timeToPlot','nel','nph','elnames','phnamesPLOT',...
        'N','v','vm','B',...
        'Np','Npm','Npv',...
        'Bp','Bpm','Bpv',...
        'Vp','Vpm','Vpv',...
        'Vmp', 'xinPhase');
  wf(i,:,:)=wfs;
  mf(i,:,:)=mfs;
  pf(i,:,:)=pfs;
  chempf(i,:,:)=chemps;
  dstf(:,i)=dist;
  tspf(i)=tstp;
  tmToPlotf(i)=timeToPlot;
  Nf(i,:)=N;
  vf(i,:)=vm;
  vmf(i,:)=vm;
  Bf(i,:)=B;
  Npf(i,:,:)=Np;
  Npmf(i,:,:)=Npm;
  Npvf(i,:,:)=Npv;
  Bpf(i,:,:)=Bp;
  Bpmf(i,:,:)=Bpm;
  Bpvf(i,:,:)=Bpv;
  Vpf(i,:,:)=Vp;
  Vpmf(i,:,:)=Vpm;
  Vpvf(i,:,:)=Vpv;
  Vmpf(i,:,:)=Vmp;
  clear wfs mfs pfs chemps dist tstp timeToPlot N v vm B Np Npm Npv Bp ...
        Bpm Bpv Vp Vpm Vpv Vmp
end
%%
    d=linspace(1,100);
%% Prompt to read file prefix
    prompt = 'file name prefix:'
    fNamesPrefix = input(prompt,'s')
%% Prompt to read xlimits    
    prompt = 'Xlow:'
    Xlow = input(prompt)
    prompt = 'Xmax:'
    Xmax = input(prompt) 
    %Xlow=0;
    %Xmax=2e-3;
%% Plot individual mole fractions
  choice = questdlg('Plot mole-fractions?','plotting','YES', 'NO', 'YES');
  switch choice
    case 'YES'
      choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
      for i = 1 :nel
        figure
        hold on
        box on
        for j = 1 : size(tstps,2)    
          mftemp(:,:) = mf(j,:,:);  
          plot(dstf(:,j), mftemp(i,:));
          xlim([Xlow,Xmax]);
          legendcell(j)=cellstr(['t= ' num2str(tmToPlotf(j)','%5.0f') ' sec']);
        end
        xlabel('Distance [m]','FontSize',15); %'Interpreter','latex'
        ylabel(['Mole-Fraction ' elnames{i}],'FontSize',15); %'Interpreter','latex',
        leg=legend(legendcell,'FontSize',15);
  %         choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
          switch choice
            case '.fig'
              saveas(gcf,[folder_name '\'  fNamesPrefix 'mfs_' elnames{i} '.fig'])
            case '.png'
              saveas(gcf,[folder_name '\'  fNamesPrefix 'mfs_' elnames{i} '.png'])
          end
%           %%%%%
%           [f,p]=uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
%           '*.*','All Files' },'Save Image',...
%           'C:\Work\newfile.jpg')
%           % https://se.mathworks.com/help/matlab/ref/uiputfile.html
%           %%%%%
      end
    end
    
%% Plot individual w fractions
  choice = questdlg('Plot weight-fractions?','plotting','YES', 'NO', 'YES');
  switch choice
    case 'YES'
      choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
      for i = 1 :nel
        figure
        hold on
        box on
        for j = 1 : size(tstps,2)    
          wftemp(:,:) = wf(j,:,:);  
          plot(dstf(:,j), wftemp(i,:));
          xlim([Xlow,Xmax]);
          legendcell(j)=cellstr(['t= ' num2str(tmToPlotf(j)','%5.0f') ' sec ']);
        end
        xlabel('Distance [m]','FontSize',15);
        ylabel(['Weight-Fraction ' elnames{i}],'FontSize',15);
        leg=legend(legendcell,'FontSize',15);
    %         choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
          switch choice
          case '.fig'
            saveas(gcf,[folder_name '\'  fNamesPrefix 'wfs' elnames{i} '.fig'])
          case '.png'
            saveas(gcf,[folder_name '\'  fNamesPrefix 'wfs' elnames{i} '.png'])          
          end
      end
  end
  
%% Plot individual phase fractions
  choice = questdlg('Plot phase-fractions?','plotting','YES', 'NO', 'YES');
  switch choice
    case 'YES'
      choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
      for i = 1 :nph
        TF = contains(phnamesPLOT(i),'ZZDICTRA-GHOST','IgnoreCase',true);
        if ~TF 
          figure
          hold on
          box on
          for j = 1 : size(tstps,2)    
            pftemp(:,:) = pf(j,:,:);  
            plot(dstf(:,j), pftemp(i,:));
            xlim([Xlow,Xmax]);
            legendcell(j)=cellstr(['t= ' num2str(tmToPlotf(j)','%5.0f') ' sec ']);
          end
          xlabel('Distance [m]','FontSize',15);
          ylabel(['Phase-Fraction ' ,phnamesPLOT{i}],'FontSize',15);
          leg=legend(legendcell,'FontSize',15);
%           choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
            switch choice
              case '.fig'
                  saveas(gcf,[folder_name '\'  fNamesPrefix 'pfs' num2str(i) '.fig'])
              case '.png'
                  saveas(gcf,[folder_name '\'  fNamesPrefix 'pfs' num2str(i) '.png'])
            end
        end    
      end
  end
  
%% Plot individual volume fractions
  choice = questdlg('Plot volume-fractions?','plotting','YES', 'NO', 'YES');
  switch choice
    case 'YES'
      choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
      TF=[];
      for i = 1 :nph
        TF = contains(phnamesPLOT(i),'ZZDICTRA-GHOST','IgnoreCase',true);
        if ~TF 
            figure
            hold on
            box on
            for j = 1 : size(tstps,2)    
                vftemp(:,:) = Vpvf(j,:,:);  
                plot(dstf(:,j), vftemp(i,:));
                xlim([Xlow,Xmax]);
                legendcell(j)=cellstr(['t= ' num2str(tmToPlotf(j)','%5.0f') ' sec ']);
            end
            xlabel('Distance [m]','FontSize',15);
            ylabel(['Volume-Fraction ' phnamesPLOT{i}],'FontSize',15);
            leg=legend(legendcell,'FontSize',15);
%             choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
            switch choice
              case '.fig'
                saveas(gcf,[folder_name '\'  fNamesPrefix 'vfs' num2str(i) '.fig'])
              case '.png'
                  saveas(gcf,[folder_name '\'  fNamesPrefix 'vfs' num2str(i) '.png'])
            end
        end    
      end 
  end
  
  %% Plot chemical potentials
choice = questdlg('Plot chemical potentials?','plotting','YES', 'NO', 'YES');
switch choice
  
    case 'YES'
      choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
        for i = 1 :nel
            figure
            hold on
            box on
            for j = 1 : size(tstps,2)    
                chemptemp(:,:) = chempf(j,:,:);  
                plot(dstf(:,j), chemptemp(i,:));
                xlim([Xlow,Xmax]);
                legendcell(j)=cellstr(['t= ' num2str(tmToPlotf(j)','%5.0f') ' sec ']);
            end
            xlabel('Distance [m]','FontSize',15);
            ylabel(['Chemical potential ' elnames{i}],'FontSize',15);      
            leg = legend(legendcell,'FontSize',15);
            leg.Location='northwest';
%             choice = questdlg('Save to file?','save to file','.fig', '.png', 'NO', 'No');
                switch choice
                    case '.fig'
                        saveas(gcf,[folder_name '\'  fNamesPrefix 'chemps' elnames{i} '.fig'])
                    case '.png'
                        saveas(gcf,[folder_name '\'  fNamesPrefix 'chemps' elnames{i} '.png'])
                end
        end  
end

%% Plot grid distribution
choice = questdlg('Plot grid points?','plotting','YES', 'NO', 'YES');
switch choice
    case 'YES'                
        for i = 1 : size(tstps,2)
            deltadist=diff(dstf(:,i));
            deltadist(size(dstf(:,i)))=0;
            figure
            plot((1:size(dstf(:,i))),deltadist,'*'); 
        end 
end   
%%
clear variables
end
    