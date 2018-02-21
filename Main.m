clear variables
close all
clc

current_path= pwd ;
folder_name = uigetdir(current_path);
%% read profiles from file/ save in a .mat file
if exist([folder_name '\postDataTmp.mat'], 'file')
    choice = questdlg('Warning: file postDataTmp exist','warning','Overwrite', 'Use the old file', 'Overwrite');
        switch choice
            case 'Overwrite'
                readProfiles(folder_name,current_path);  
        end
else
    %warningMessage = sprintf()
    %uiwait(msgbox(warningMessage));
    readProfiles(folder_name,current_path);
end
%% read timesteps from input
load([folder_name '\postDataTmp.mat'], 'TIME', 'ndt');
S1 = 'Simulated time is: ';
S2 = 'Number of times steps is: ';
S3 = 'Please select timesteps to plot (none zero posetive integers smaller than number of times steps, space seperated:)';
x = inputdlg([S1 num2str(TIME(end)) ', ' S2 num2str(ndt) ', ' S3],...
             'Sample', [1 200]);        
tstps = unique(sort( floor(str2num(x{:}))));
tstps = tstps(tstps>0);
tstps = tstps(tstps<=ndt);
if isempty(tstps)
    tstps=[1 ndt]
end
clear S1 S2 S3 x ndt TIME ;
%% read time steps from file and save to .mat file
for i = 1: size(tstps,2)
    tstpReader(tstps(i),folder_name);
end
clear i;
%% plot time steps
plotter(tstps,folder_name)
%%