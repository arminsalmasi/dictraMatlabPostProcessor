close all
clear variables



figure
hold on 
box on
plotter('C:\Users\armin\Google Drive\MyPhD\Projects\Ni_isotop\fs_1_924.mat','C:\Users\armin\Google Drive\MyPhD\Projects\Ni_isotop\1\')
plotter('C:\Users\armin\Google Drive\MyPhD\Projects\Ni_isotop\fs_2_924.mat','C:\Users\armin\Google Drive\MyPhD\Projects\Ni_isotop\2\')
plotter('C:\Users\armin\Google Drive\MyPhD\Projects\Ni_isotop\fs_3_924.mat','C:\Users\armin\Google Drive\MyPhD\Projects\Ni_isotop\3\')


lg = legend({'VPV U $f^{1.5}$','VPV TC $f^{1.5}$','VPV TC $\frac{f-0.04)}{1-0.04}^{1.5}$'})
set(lg, 'Interpreter', 'LaTex')
xlabel('mole fraction A')
ylabel('distance')
xlim([8e-3 , 1e-2])
title('924 sec')