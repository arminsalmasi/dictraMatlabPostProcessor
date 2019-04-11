clear variables; close all; clc;
current_path= pwd ;
folder_name = uigetdir(current_path);

poly3path = [folder_name '\5.POLY3']%'W:\carbon_activity_1\5.POLY3'
%% read profiles from file/ save in the postDataTmp.mat

if exist([folder_name 'postDataTmp.mat'], 'file')
    choice = questdlg('Warning: file postDataTmp exist','warning','Overwrite', 'Use the old file', 'Overwrite');
    switch choice
        case 'Overwrite'
            [TIME ndt] = readProfiles(folder_name,current_path);
        case 'Use the old file'
            load([folder_name '\postDataTmp.mat'],'TIME');
            ndt=size(TIME,1);
    end
else
    [TIME ndt] = readProfiles(folder_name,current_path);
end
message = sprintf('%s','Read profile : DONE');
clear message choice current_path

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
%% plot time steps
choice = questdlg('Select plot atributes','plotter','+Boundaries', 'midPoints', '+Boundaries');
switch choice
    case '+Boundaries'
        altPlotter(tstps,folder_name,TIME);
    case 'midPoints'
        plotter(tstps,folder_name,TIME);
end