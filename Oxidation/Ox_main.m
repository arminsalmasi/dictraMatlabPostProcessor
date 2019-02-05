%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1nd step -read -save
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear variables;close all;clc
% current_path= pwd;folder_name = uigetdir(current_path);
% % read profiles from file/ save in a .mat file
% if exist([folder_name '\KirkendalDataTmp.mat'], 'file')
%   choice = questdlg('Warning: file postDataTmp exist','warning','Overwrite', 'Use the old file', 'Overwrite');
%   switch choice
%     case 'Overwrite'
%       [TIME] = Kirkendall_readProfiles(folder_name,current_path);
%     case 'Use the old file'
%       load([folder_name '\postDataTmp.mat'],'TIME');
%   end
% else
%   [TIME] = Kirkendall_readProfiles(folder_name,current_path);
% end
% message = sprintf('%s','Read profile : DONE')
% clear message choice 
% 
% % read data of all timesteps
% ndt = size(TIME,1)
% tstps=[1:ndt];
% flxhold=[];
% for i = 1: ndt
%   fname= ['fs_t_' num2str(TIME(tstps(i)),'%10.0f')];
%   [flxhold(i*5-4:i*5,:) cBnd(i,:)]= Kirkendall_tstpReader(i,folder_name,TIME);
% end
% % extra data
% save([pwd '\extra'],'flxhold','cBnd','TIME','ndt','tstps','folder_name' );
% A='DONE'
% clear all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2nd step -load -plot
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc;

up=2e-5;low=1e-7;step=0.5e-6;
marker=low:step:up;


load([pwd '\extra'],'flxhold','cBnd','TIME','ndt','tstps','folder_name' );

Kirkendall_markerPlotter(folder_name,marker,TIME)
fluxPlotter(flxhold,cBnd, ndt,TIME,folder_name)

