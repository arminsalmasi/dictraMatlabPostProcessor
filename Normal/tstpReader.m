%% function tstpreader
function []=tstpReader(tstp,folder_name,TIME, poly3path)
load([folder_name '\postDataTmp.mat'], 'VOLUMES_PER_REGION',...
  'VOLUME_MIDPOINTS', 'MOLE_FRACTIONS', 'CHEMICAL_POTENTIALS',...
  'PHASE_FRACTIONS', 'nel', 'nph', 'M','elnames',...
  'phnames','phnamesPLOT','phnamesTC','BOUNDARIES');
%% read fvcc x
str_p_dist = sum(VOLUMES_PER_REGION(1:tstp-1))+1;
end_p_dist = sum(VOLUMES_PER_REGION(1:tstp));
dist = VOLUME_MIDPOINTS(str_p_dist : end_p_dist);
%% read all mole fractions of the timestep
str_p_mf = (tstp-1)*(VOLUMES_PER_REGION(tstp))*nel+1;
end_p_mf = tstp*(VOLUMES_PER_REGION(tstp))*nel;
allMfs_inTstp = MOLE_FRACTIONS(  str_p_mf : end_p_mf);
%% read all chemical potentials of the timestep
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
  pfs(i,:)= allPfs_inTstp(i:nph:end);
end
%% read chemical potentials
for i = 1 : nel
  chemps(i,:)= allChemps_inTstp(i:nel:end);
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
%% TC Calculator
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
N=1;P=101325;T=1723.15;
% %   dtbs='TCFE9';
%% Select elements and phases and retrieve data
% %   tc_define_system(dtbs,sel,{'*'},phs);
% %   tc_get_data;
% %   
% % % %   dtbs='USER E:\Dropbox\1-KTH_PHD\Projects\EXTRAS\KinThermo_data\Mob_AIMD_27.01.2016_Armin3-FH-80char.TDB';
% % % %   %dtbs='mobfe3';
% % % % %% Select elements and phases and retrieve data
% % % %   tc_append_database(dtbs);
% % % %   tc_define_components(sel);
% % % %   tc_phase_select('liquid');
% % % %   tc_get_data;

tc_read_poly3_file(poly3path)

%% set conditions
tctoolbox('tc_set_condition', 'n', N);
tctoolbox('tc_set_condition', 'p', P);%101325
tctoolbox('tc_set_condition', 't', T);
for j= 1: size(mfs,2)
  %tic
  for i = 1: (size(Xi_names,2)-1)
    tctoolbox('tc_set_condition',char(Xi_names(i)), mfs(i,j));
  end
  %% compute equilibrium
  tc_compute_equilibrium;
  %toc
  %% Read volume data
  TF=[];
  for i=1:size(phnames,2)
    TF = contains(phnames(i),'ZZDICTRA_GHOST','IgnoreCase',true);
    if ~TF
      Vpv(i,j) = tc_get_value(char(['vpv(' char(phnames(i)) ')']));
      for ik=1: size(elnames,2)
        mole_fraction_in_phase(j,i,ik) = tc_get_value(char(['x(' char(phnames(i)) ',' char(elnames(ik)) ')']));
        Mobility_in_phase(j,i,ik)= tc_get_value(char(['M(' char(phnames(i)) ',' char(elnames(ik)) ')']));
      end
    end
  end
 
end


%//////////////////////////////////////////////////////////////////////////
%% adjust boundaries
%% Save data for plotting
fname= ['fs_t_' num2str(TIME(tstp),'%10.0f')];
timeToPlot=TIME(tstp);
save([folder_name '\' fname],'wfs', 'mfs', 'pfs','chemps','dist',...
       'timeToPlot','nel','nph','elnames','phnamesPLOT','Vpv','mole_fraction_in_phase','Mobility_in_phase');   
%% alternative data for plotting - boundaries added
%% Save data for plotting
fname= ['Alt_fs_t_' num2str(TIME(tstp),'%10.0f')];
%msg5 = ['Variables are saved to ' fname '.mat'];
%sprintf('%s',msg5)
bnd = BOUNDARIES(2*tstp-1:2*tstp);
dist= [bnd(1,1);dist(1:end,1);bnd(2,1)];
wfs= [wfs(:,1),wfs(:,:),wfs(:,end)];
mfs= [mfs(:,1),mfs(:,:),mfs(:,end)];
pfs= [pfs(:,1),pfs(:,:),pfs(:,end)];
chemps= [chemps(:,1),chemps(:,:),chemps(:,end)];
Vpv = [Vpv(:,1),Vpv(:,:),Vpv(:,end)];
timeToPlot=TIME(tstp);
save([folder_name '\' fname],'wfs', 'mfs', 'pfs','chemps','dist',...
       'timeToPlot','nel','nph','elnames','phnamesPLOT','Vpv','mole_fraction_in_phase','Mobility_in_phase');    
end








%   %% read all fluxes of the timestep
%     str_p_fl = (tstp-1)*(VOLUMES_PER_REGION(tstp)+1)*nel+1;
%     end_p_fl = tstp*(VOLUMES_PER_REGION(tstp)+1)*nel;
%     allflx_inTstp = FLUXES(str_p_pf : end_p_pf);

%% Calculate volume fractions
%for i = 1 : size(mfs,2)
%[v(i,:),vpv(i,:),vm(i,:),vmtot(i)]=...
%singlepoint(elnames,phnamesTC,mfs(:,i),1670,101325,1,'tcfe9');%(elnames,phnamesTC,mfs,T,P,N,dtbs)
%sprintf('%s' , [num2str(i) ' point out of ' num2str(size(mfs,2)) ' points'])
%end
%% read fluxes
% for i = 1 : nel
%   flx(i,:)= allflx_inTstp(i:nel:end);
% end


%       Np(i,j)  = tc_get_value(char(['Np( ' char(phnames(i)) ')']));
%       Npm(i,j) = tc_get_value(char(['Npm(' char(phnames(i)) ')']));
%       Npv(i,j) = tc_get_value(char(['Npv(' char(phnames(i)) ')']));
%       Bp(i,j)  = tc_get_value(char(['Bp( ' char(phnames(i)) ')']));
%       Bpm(i,j) = tc_get_value(char(['Bpm(' char(phnames(i)) ')']));
%       Bpv(i,j) = tc_get_value(char(['Bpv(' char(phnames(i)) ')']));
%       Vp(i,j)  = tc_get_value(char(['Vp( ' char(phnames(i)) ')']));
%       Vpm(i,j) = tc_get_value(char(['vpm(' char(phnames(i)) ')']));
%       Vmp(i,j) = tc_get_value(char(['vm( ' char(phnames(i)) ')']));
%       for k = 1: nel
%        xinPhase(i,k,j) = tc_get_value(char(strcat('x(', char(phnames(i)),',',cellstr(elnames{k}), ')')));
%       end
% N = tc_get_value('N');
%   v(j) = tc_get_value('v');
%   vm(j) = tc_get_value('vm');
%   B(j) = tc_get_value('B');  

  %   [aa] = tc_degrees_of_freedom;
  %     sprintf('%s', ['DOF = ' num2str(aa)] )