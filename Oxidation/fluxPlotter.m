function []=fluxPlotter(flxhold,cBnd,ndt,TIME,folder_name)
%% read and plot fluxes
close all
flxc=flxhold(1:5:end,:);
flxco=flxhold(2:5:end,:);
flxn=flxhold(3:5:end,:);
flxti=flxhold(4:5:end,:);
flxw=flxhold(5:5:end,:);
flxsumall = flxc+flxco+flxn+flxti+flxw;
flxsumSub =flxco+flxti+flxw;
flxsumTiN =flxn+flxti;

%% JC
%tt=[2 floor(ndt/2) ndt];
tt=[2 500 ndt]
a=figure;hold on;box on;grid on; k=1;
for t=tt
  plot(cBnd(t,:),flxc(t,:));k=k+1;
end
leg=legend(['t=' num2str(TIME(tt(1,1)))], ['t=' num2str(TIME(tt(1,2)))], ['t=' num2str(TIME(tt(1,3)))],'Interpreter','latex');
leg.Interpreter='latex'

ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);xlim([0 0.1e-3]);
ylabel('$J_C$', 'Interpreter','latex','FontSize',20)
xlabel('$Distance (m)$', 'Interpreter','latex','FontSize',20)
saveas(gcf,[folder_name '\jc.fig'])


%% JCo
a=figure;hold on;box on;grid on; k=1;
for t=tt
  plot(cBnd(t,:),flxco(t,:));k=k+1;
end
leg=legend(['t=' num2str(TIME(tt(1,1)))], ['t=' num2str(TIME(tt(1,2)))], ['t=' num2str(TIME(tt(1,3)))],'Interpreter','latex');
leg.Interpreter='latex'
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);xlim([0 0.1e-3]);
ylabel('$J_{Co}$', 'Interpreter','latex','FontSize',20)
xlabel('$Distance (m)$', 'Interpreter','latex','FontSize',20)
saveas(gcf,[folder_name '\jco.fig'])


%% JN
a=figure;hold on;box on;grid on; k=1;
for t=tt
  plot(cBnd(t,:),flxn(t,:));k=k+1;
end
leg=legend(['t=' num2str(TIME(tt(1,1)))], ['t=' num2str(TIME(tt(1,2)))], ['t=' num2str(TIME(tt(1,3)))],'Interpreter','latex');
leg.Interpreter='latex'
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);xlim([0 0.1e-3]);
ylabel('$J_{N}$', 'Interpreter','latex','FontSize',20)
xlabel('$Distance (m)$', 'Interpreter','latex','FontSize',20)
saveas(gcf,[folder_name '\jn.fig'])


%% JTi
a=figure;hold on;box on;grid on; k=1;
for t=tt
  plot(cBnd(t,:),flxti(t,:));k=k+1;
end
leg=legend(['t=' num2str(TIME(tt(1,1)))], ['t=' num2str(TIME(tt(1,2)))], ['t=' num2str(TIME(tt(1,3)))],'Interpreter','latex');
leg.Interpreter='latex'
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);xlim([0 0.1e-3]);
ylabel('$J_{Ti}$', 'Interpreter','latex','FontSize',20)

xlabel('$Distance (m)$', 'Interpreter','latex','FontSize',20)
saveas(gcf,[folder_name '\jti.fig'])


%% Jw
a=figure;hold on;box on;grid on; k=1;
for t=tt
  plot(cBnd(t,:),flxw(t,:));k=k+1;
end
leg=legend(['t=' num2str(TIME(tt(1,1)))], ['t=' num2str(TIME(tt(1,2)))], ['t=' num2str(TIME(tt(1,3)))],'Interpreter','latex');
leg.Interpreter='latex'
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);xlim([0 0.1e-3]);
xlabel('$Distance (m)$', 'Interpreter','latex','FontSize',20)
ylabel('$J_{W}$', 'Interpreter','latex','FontSize',20)

saveas(gcf,[folder_name '\jw.fig'])


%% Jsub
a=figure;hold on;box on;grid on; k=1;
for t=tt
  plot(cBnd(t,:),flxsumSub(t,:)); k=k+1;
end
leg=legend(['t=' num2str(TIME(tt(1,1)))], ['t=' num2str(TIME(tt(1,2)))], ['t=' num2str(TIME(tt(1,3)))],'Interpreter','latex');
leg.Interpreter='latex'
xlabel('$Distance (m)$', 'Interpreter','latex','FontSize',20)
ylabel('$J_{sub}$', 'Interpreter','latex','FontSize',20)
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);
xlim([0 0.1e-3]);
saveas(gcf,[folder_name '\jsub.fig'])


end



