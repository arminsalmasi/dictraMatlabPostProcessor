function []=Kirkendall_markerPlotter(folder_name, markerInit, TIME)
marker = markerInit;
ndt=size(TIME,1);
for i = 1 : ndt
  fname= ['kirkendal_t_' num2str(TIME(i),'%10.0f') '.mat'];
  load([folder_name '\' fname],'nel','flx','Vm','cBnd');
  flxf(i,:,:)=flx;
  Vmf(i,:)=Vm;
  %bnd(i,:)=[fliplr(-1*cBnd(2:end)'),cBnd']';
  bnd(i,:)=cBnd;
  clear Vm flx tstp cBnd 
end
V=0*marker;MarkerH=[];VH=[];
VmMarker= V;JvaMarker=V;
%V=zeros(1,size(marker,2))
for t= 1:ndt-1
  MarkerH(t,:)=marker; VH(t,:)=V;
  dt=TIME(t+1,1)-TIME(t,1);
  [V marker VmMarker JvaMarker]= markerV(flxf(t,:,:),Vmf(t,:),dt,marker,bnd(t,:));
  VmMarkerH(t,:)=VmMarker;
  JvaMarkerH(t,:)=JvaMarker;
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   gtm = [0	4.42E-07	1.88E-06	1.92E-06	3.80E-06	3.80E-06	5.64E-06	7.62E-06	7.62E-06	9.62E-06	9.82E-06	1.21E-05	1.21E-05	1.21E-05	1.45E-05];   %gradTicknessMarkerposition
%   gtt= [0	97	204	310	417	523	1055	1587	2119	2652	3184	3716	4248	4780	5300];%gradTicknessMarkertime
   glastZ= 1.45E-05;
   glastt=5300;
   gk=glastZ/sqrt(glastt);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Z VS t
fig = figure('rend','painters','pos',[100 100 1200 1000]);
hold on
box on
grid on
for dataN = 1:size(MarkerH, 2)
  dataY = MarkerH(:, dataN);
  dataX = TIME(1:end-1);
  plot(dataX,dataY,'k');
end
ax=gca;
ax.TickLabelInterpreter= 'latex';
xlabel('$Time$', 'Interpreter','latex')
ylabel('$Marker \: position$', 'Interpreter','latex')
set(findall(fig, 'Type', 'Line'),'LineWidth',1);
xlim([0 TIME(end)]);
ylim([0 markerInit(end)]);
set(ax,'fontsize',20);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot(gtt,gtm,'r -.','LineWidth',3);
 tg=0:5300;
 plot(tg,gk*sqrt(tg),'r -.','LineWidth',3)
 saveas(gcf,[folder_name '\zt.fig'])

hold off
 
%% Z VS sqrt(t)
fig = figure('rend','painters','pos',[100 100 1200 1000]);
hold on
box on
grid on
for dataN = 1:size(MarkerH, 2)
  dataY = MarkerH(:, dataN);
  dataX = sqrt(TIME(1:end-1));
  plot(dataX,dataY,'k');
end
xlabel('$\sqrt{t}$', 'Interpreter','latex');
ylabel('$Marker \: position$', 'Interpreter','latex');
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(findall(fig, 'Type', 'Line'),'LineWidth',1);
xlim([0 sqrt(TIME(end))]);
ylim([0 markerInit(end)]);
set(gca,'fontsize',20);
plot(sqrt(tg),gk*sqrt(tg),'r -.','LineWidth',3)
saveas(gcf,[folder_name '\zsqrtt.fig'])
  
%  plot(sqrt(gtt),gtm,'r -.','LineWidth',3);

%%
% figure 
% surf(VmMarkerH(1:10:end,1:10:end))
% figure
% surf(MarkerH(1:10:end,1:10:end))
% figure
% surf(VH(1:10:end,1:10:end))
% figure
% surf(JvaMarkerH(1:10:end,1:10:end)) 
end



% % v*sqrt(t) VS z/SQRT(t)
% fig = figure('rend','painters','pos',[100 100 1200 1000]);
% hold on
% box on
% grid on
%  for dataN = 11:size(MarkerH, 2)
%    dataX = MarkerH(:, dataN)./ sqrt(TIME(2:end));
%    dataY = VH(:, dataN).* sqrt(TIME(2:end));
%    plot(dataX(2:end),dataY(2:end),'k *');
%  end
% 
% 
% xlabel('$Z \over \sqrt{t} $', 'Interpreter','latex')
% ylabel('$V \: \sqrt{t}  $','Interpreter','latex')
% set(findall(gca, 'Type', 'Line'),'LineWidth',2);
% set(gca,'fontsize',20)



%plot(ttt,(-5e-13*ttt.^2.+5e-9*ttt),'b -.','LineWidth',3);
% p =polyfit(gtt,gtm,2)
% x2 = 1:5300;
% y2 = polyval(p,x2);
% plot(x2,y2,'b -.','LineWidth',3)