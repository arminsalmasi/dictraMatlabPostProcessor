%% function tstpreader
function [flx,cBnd]=Kirkendall_tstpReader(tstp,folder_name,TIME)
  load([folder_name '\KirkendalDataTmp.mat'], 'VOLUMES_PER_REGION',...
  'VOLUME_MIDPOINTS',  'nel', 'FLUXES', 'MOLAR_VOLUME','BOUNDARIES');
%% read fvcc x
    startPoint=[];endPoint=[];
    startPoint = sum(VOLUMES_PER_REGION(1:tstp-1))+1;
    endPoint = sum(VOLUMES_PER_REGION(1:tstp));
    dist = VOLUME_MIDPOINTS(startPoint : endPoint);
%% read Molar volumes
    startPoint=[];endPoint=[];
    startPoint = sum(VOLUMES_PER_REGION(1:tstp-1))+1;
    endPoint = sum(VOLUMES_PER_REGION(1:tstp));
    Vm = MOLAR_VOLUME(startPoint : endPoint);    
  %% read all fluxes of the timestep       
    startPoint=[];endPoint=[];
    startPoint = (tstp-1)*(VOLUMES_PER_REGION(tstp)+1)*nel+1;
    endPoint = tstp*(VOLUMES_PER_REGION(tstp)+1)*nel;
    fluxesInTstp = FLUXES(startPoint : endPoint);    
  %% read fluxe
    for i = 1 : nel
      flx(i,:)= fluxesInTstp(i:nel:end);
    end
  %% read boundaries
    bnd = BOUNDARIES(2*tstp-1:2*tstp);
    cBnd=[bnd(1);(dist(1:end-1,1)+dist(2:end,1))/2;bnd(2)];
  %% Save data for plotting
  fname= ['kirkendal_t_' num2str(TIME(tstp),'%10.0f')];
   msg5 = ['Variables are saved to ' fname '.mat'];
   sprintf('%s',msg5)
  timeToPlot=TIME(tstp);
  save([folder_name '\' fname],'nel','flx','Vm','cBnd');
end

%cBnd = zeros(size(dist,1)+1,1);   cBnd(1)=bnd(1); %domain size       cBnd(end)=bnd(2); %domain size       cBnd(2:end-1) = (dist(1:end-1,1)+dist(2:end,1))/2;
