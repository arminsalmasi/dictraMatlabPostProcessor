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
    [TIME ndt] = readProfiles(folder_name);
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