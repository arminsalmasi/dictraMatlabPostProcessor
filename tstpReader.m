% read timestep to plot from input
function []=tstpReader(tstp,folder_name)

  load([folder_name '\postDataTmp.mat'], 'VOLUMES_PER_REGION',...
  'VOLUME_MIDPOINTS', 'MOLE_FRACTIONS', 'CHEMICAL_POTENTIALS',...
  'PHASE_FRACTIONS', 'nel', 'nph', 'TIME', 'ndt', 'M','elnames',...
  'phnames','phnamesTC','phnamesPLOT');

  %% read grid point x
    str_p_dist = sum(VOLUMES_PER_REGION(1:tstp-1))+1;
    end_p_dist = sum(VOLUMES_PER_REGION(1:tstp));
    dist = VOLUME_MIDPOINTS(str_p_dist : end_p_dist);
    
  %% read all mole fractions of the timestep
    str_p_mf = (tstp-1)*(VOLUMES_PER_REGION(tstp))*nel+1;
    end_p_mf = tstp*(VOLUMES_PER_REGION(tstp))*nel;
    allMfs_inTstp = MOLE_FRACTIONS(  str_p_mf : end_p_mf);
    
  %% read all hemical potentials of the timestep
    str_p_chemp = (tstp-1)*(VOLUMES_PER_REGION(tstp))*nel+1;
    end_p_chemp = tstp*(VOLUMES_PER_REGION(tstp))*nel;
    allChemps_inTstp = CHEMICAL_POTENTIALS(str_p_chemp : end_p_chemp);
    
  %% read all phase fractions of the timestep
    str_p_pf = (tstp-1)*(VOLUMES_PER_REGION(tstp))*nph+1;
    end_p_pf = tstp*(VOLUMES_PER_REGION(tstp))*nph;
    allPfs_inTstp = PHASE_FRACTIONS(str_p_pf : end_p_pf);
    
  %% read elemental fractions 
    for i = 1 : nel
      mfs(i,:)= allMfs_inTstp(i:nel:end);
    end
    
  %% read phasal fractions
    for i = 1 : nph
      pfs(i,:)= allPfs_inTstp(i:nel:end);    
    end
    
  %% read chemical potentials 
    for i = 1 : nph
      chemps(i,:)= allChemps_inTstp(i:nph:end);    
    end

  %% Calculate wight fractions
    for i = 1 : size(dist,1)
      mtot(i) = sum(mfs(1:nel,i).* M(1:nel)'); 
    end

    for j=1:size(dist,1)
      for i = 1 :nel
        wfs(i,j)=  (mfs(i,j)*M(1,i))/mtot(j);
      end
    end
  %% Calculate volume fractions
    %for i = 1 : size(mfs,2)
      %[v(i,:),vpv(i,:),vm(i,:),vmtot(i)]=...
      %singlepoint(elnames,phnamesTC,mfs(:,i),1670,101325,1,'tcfe9');%(elnames,phnamesTC,mfs,T,P,N,dtbs)
      %sprintf('%s' , [num2str(i) ' point out of ' num2str(size(mfs,2)) ' points'])         
    %end
  %//////////////////////////////////////////////////////////////////////////   
    sel =[];    
    for i = 1 : size(elnames,2)
      Xi_names(i) = cellstr([ 'X(' elnames{i} ')']);
      if i==1
        sel = strcat(sel,elnames{i});
      else
        sel = strcat(sel, {' '}, elnames{i});
      end
    end
    phs =[];
    for i = 1 : size(phnamesTC,2)
      if i==1
        phs = strcat(phs,phnamesTC{i});
      else
        phs = strcat(phs, {' '}, phnamesTC{i});
      end
    end   
  %% Initiate the TC system
    tc_init_root;
  %% Choose database %dtbs='TCFE9'; %tc_open_database('TCFE9');
    dtbs='TCFE9';N=1;P=101325;T=1673;
  %% Select elements and phases and retrieve data
    tc_define_system(dtbs,sel,{'*'},phs);
    tc_get_data;
  %% set conditions 
    tctoolbox('tc_set_condition', 'n', N);
    tctoolbox('tc_set_condition', 'p', P);%101325
    tctoolbox('tc_set_condition', 't', T);
    for j= 1: size(mfs,2)    
      %tic
      for i = 1: (size(Xi_names,2)-1)
        tctoolbox('tc_set_condition',char(Xi_names(i)), mfs(i,j));
      end
  %   [aa] = tc_degrees_of_freedom;
  %     sprintf('%s', ['DOF = ' num2str(aa)] )
      %% compute equilibrium
        tc_compute_equilibrium;
        %toc
      %% Read volume data
        TF=[];
        for i = 1 :  size(phnamesTC,2)
          TF = contains(phnamesTC(i),'ZZDICTRA_GHOST','IgnoreCase',true);
          if ~TF         
            Np(i,j)  = tc_get_value(char(['Np( ' char(phnamesTC(i)) ')']));
            Npm(i,j) = tc_get_value(char(['Npm(' char(phnamesTC(i)) ')']));
            Npv(i,j) = tc_get_value(char(['Npv(' char(phnamesTC(i)) ')']));
            Bp(i,j)  = tc_get_value(char(['Bp( ' char(phnamesTC(i)) ')']));
            Bpm(i,j) = tc_get_value(char(['Bpm(' char(phnamesTC(i)) ')']));
            Bpv(i,j) = tc_get_value(char(['Bpv(' char(phnamesTC(i)) ')']));
            Vp(i,j)  = tc_get_value(char(['Vp( ' char(phnamesTC(i)) ')']));          
            Vpm(i,j) = tc_get_value(char(['vpm(' char(phnamesTC(i)) ')']));
            Vpv(i,j) = tc_get_value(char(['vpv(' char(phnamesTC(i)) ')']));
            Vmp(i,j) = tc_get_value(char(['vm( ' char(phnamesTC(i)) ')']));
          end        
        end
        
        N = tc_get_value('N');
        v(j) = tc_get_value('v');
        vm(j) = tc_get_value('vm');
        B(j) = tc_get_value('B');
        
    end
  %//////////////////////////////////////////////////////////////////////////    
  %% Save data for plotting
  fname= ['fs_t_' num2str(TIME(tstp),'%10.0f')];
  msg5 = ['Variables are saved to ' fname '.mat'];
  sprintf('%s',msg5)
  timeToPlot=TIME(tstp);
  save([folder_name '\' fname],...
    'wfs','mfs','pfs','chemps','dist','tstp',...
    'timeToPlot','nel','nph',...
    'elnames','phnames','phnamesPLOT',...
    'N','v','vm','B',...
    'Np','Npm','Npv',...
    'Bp','Bpm','Bpv',...
    'Vp','Vpm','Vpv',...
    'Vmp');
  %%
  clear variables
end
