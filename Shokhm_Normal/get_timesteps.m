% load([folder_name '\postDataTmp.mat'],'TIME');
% ndt=size(TIME,1);
%% read timesteps from input
S1='Simulated time is: ';S2 = 'Number of times steps is: ';S3='select timesteps to plot (none zero posetive integers smaller than number of times steps, space seperated:)';
x=inputdlg([S1 num2str(TIME(end)) ', ' S2 num2str(ndt) ', ' S3],'Sample', [1 200]);
tstps=unique(sort( floor(str2num(x{:}))));
tstps=tstps(tstps>0);
tstps=tstps(tstps<=ndt);
if isempty(tstps)
    tstps=[1 ndt];
end
clear S1 S2 S3 x ndt;
%% read time steps from file and save to .mat file
for i = 1: size(tstps,2)
    tstpReader(tstps(i),folder_name,TIME, poly3path);
end
message = sprintf('%s','Read timesteps : DONE');
clear i choice fname message;


%% function tstpreader
function []=tstpReader(tstp,folder_name,TIME, poly3path)
load([folder_name '\postDataTmp.mat'], 'VOLUMES_PER_REGION',...
'VOLUME_MIDPOINTS', 'MOLE_FRACTIONS', 'CHEMICAL_POTENTIALS',...
'PHASE_FRACTIONS', 'nel', 'nph','elnames',...
'phaseNames','phaseNamesForPlot', 'phaseNamesForThermoCalc',...
'BOUNDARIES','TIME','FLUXES','flagToPlotVolume','MOLAR_VOLUME');
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
for i = 1 : nel
  chemps(i,:)= allChemps_inTstp(i:nel:end);
end
%% Calculate wight fractions
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
for i = 1 : size(phaseNamesForThermoCalc,2)
  if i==1
    phs = strcat(phs,phaseNamesForThermoCalc{i});
  else
    phs = strcat(phs, {' '}, phaseNamesForThermoCalc{i});
  end
end

tc_init_root;
N=1;P=101325;T=1723.15;
tc_read_poly3_file(poly3path)
tctoolbox('tc_set_condition', 'n', N);
tctoolbox('tc_set_condition', 'p', P);
tctoolbox('tc_set_condition', 't', T);
for j= 1: size(mfs,2)
  for i = 1: (size(Xi_names,2)-1)
    tctoolbox('tc_set_condition',char(Xi_names(i)), mfs(i,j));
  end
  tc_compute_equilibrium;
  TF=[];
  for i=1:size(phaseNames,2)
    TF = contains(phaseNames(i),'ZZDICTRA_GHOST','IgnoreCase',true);
    if ~TF
      Vpv(i,j) = tc_get_value(char(['vpv(' char(phaseNames(i)) ')']));
      for ik=1: size(elnames,2)
        mole_fraction_in_phase(j,i,ik) = tc_get_value(char(['x(' char(phaseNames(i)) ',' char(elnames(ik)) ')']));
        Mobility_in_phase(j,i,ik)= tc_get_value(char(['M(' char(phaseNames(i)) ',' char(elnames(ik)) ')']));
      end
    end
  end 
end
%% adjust boundaries
%% Save data for plotting
fname= ['fs_t_' num2str(TIME(tstp),'%10.0f')];
timeToPlot=TIME(tstp);
save([folder_name '\' fname], 'mfs', 'pfs','chemps','dist',...
       'timeToPlot','nel','nph','elnames','phaseNamesForPlot','Vpv','mole_fraction_in_phase','Mobility_in_phase');   
%% alternative data for plotting - boundaries added
%% Save data for plotting
fname= ['Alt_fs_t_' num2str(TIME(tstp),'%10.0f')];
bnd = BOUNDARIES(2*tstp-1:2*tstp);
dist= [bnd(1,1);dist(1:end,1);bnd(2,1)];
mfs= [mfs(:,1),mfs(:,:),mfs(:,end)];
pfs= [pfs(:,1),pfs(:,:),pfs(:,end)];
chemps= [chemps(:,1),chemps(:,:),chemps(:,end)];
Vpv = [Vpv(:,1),Vpv(:,:),Vpv(:,end)];
timeToPlot=TIME(tstp);
save([folder_name '\' fname], 'mfs', 'pfs','chemps','dist',...
       'timeToPlot','nel','nph','elnames','phaseNamesForPlot','Vpv','mole_fraction_in_phase','Mobility_in_phase');    
end