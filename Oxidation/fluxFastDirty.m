%flux fast and dirty

close all
clear all
%path= 'C:\Users\salmasi\Desktop\10-300gp-1um\'
path= 'E:\Dropbox\1-KTH_PHD\Projects\GradientSintering\Simulations\10-jfp009\10-Dictra\10-1D-F25-TCFE8-AIMD\'
load([path 'FLUXES.TXT']);
load([path 'TIME.TXT']);
load([path 'VOLUMES_PER_REGION.TXT']);
%load('C:\Users\salmasi\Documents\Mycodes\DICTRAMATLABPost\NumberFixed\test\TIME.TXT')
%load('C:\Users\salmasi\Documents\Mycodes\DICTRAMATLABPost\NumberFixed\test\TIME.TXT')
nel=5;
load([path 'CHEMICAL_POTENTIALS.TXT']);
load([path 'MOLE_FRACTIONS.TXT']);
load([path 'VOLUME_MIDPOINTS.TXT']);



  %% read all fluxes of the timestep       
 tstp=size(TIME,1)
 TIME(tstp)
 tstp=44
    startPoint=[];endPoint=[];
    startPoint = (tstp-1)*(VOLUMES_PER_REGION(tstp)+1)*nel+1;
    endPoint = tstp*(VOLUMES_PER_REGION(tstp)+1)*nel;
    fluxesInTstp = FLUXES(startPoint : endPoint);
    for i=4:4
      flx(:)= fluxesInTstp(i:nel:end,1);
       figure;
       plot(flx);
    end   

  tstp=size(TIME,1)
 TIME(tstp)
 tstp=44
    startPoint=[];endPoint=[];
    startPoint = (tstp-1)*(VOLUMES_PER_REGION(tstp))*nel+1;
    endPoint = tstp*(VOLUMES_PER_REGION(tstp))*nel;
    mf = MOLE_FRACTIONS(startPoint : endPoint);
    for i=4:4
      mff(:)= mf(i:nel:end,1);
       figure;
       plot(mff);
    end   

    
    
    
    
tstp=size(TIME,1)
 TIME(tstp)
 tstp=44
    startPoint=[];endPoint=[];
    startPoint = (tstp-1)*(VOLUMES_PER_REGION(tstp))*nel+1;
    endPoint = tstp*(VOLUMES_PER_REGION(tstp))*nel;
    mf = CHEMICAL_POTENTIALS(startPoint : endPoint);
    for i=4:4
      mff(:)= (mf(i:nel:end,1));
       figure;
       plot(VOLUME_MIDPOINTS(1:end-1), mff);
    end   

 