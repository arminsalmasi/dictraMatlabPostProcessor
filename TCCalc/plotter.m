clc
close all

a=figure;
hold on;box on;
plot(GP',labfact,'*-');
%title('$ \lambda=f_{\beta} ^{2.5{ $','Interpreter','tex');
ax=gca;
ax.TickLabelInterpreter= 'latex';
set(ax,'fontsize',20);
ylabel(' $\lambda=f_{\beta} ^{2.5} $','Interpreter','latex');
xlabel('Distance (m)','Interpreter','latex')
set(findall(a, 'Type', 'Line'),'LineWidth',1);
savefig('labfact.fig');




a=figure;
hold on;box on;
for i=1:5
plot(GP',uf_liq(i,:));
legendcell(i)=cellstr([num2str(i)]);
end
%leg=legend(legendcell)
leg=legend(elnames,'Interpreter','latex');
ax=gca;
ax.TickLabelInterpreter= 'latex';
%title('u_k ^{\beta}','Interpreter','latex' );
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);
xlabel('$Distance (m)$','Interpreter','latex')
ylabel('$u_k ^{\beta}$','Interpreter','latex')
savefig('uf.fig')



a=figure;
hold on;box on;
for i=1:nel
plot(GP',mob_el_in_liq(i,:));
legendcell(i)=cellstr([num2str(i)]);
end
leg=legend(elnames,'Interpreter','latex');
ax=gca;
ax.TickLabelInterpreter= 'latex';
xlabel('$Distance (m)$','Interpreter','latex')
ylabel('$M_k ^{\beta}$','Interpreter','latex' );
%title('M_k ^{\beta}','Interpreter','latex' )
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);
savefig('mob_in_liquid.fig')


a=figure;
hold on;box on;
for i=1:5
plot(GP',Gamma(i,:));
legendcell(i)=cellstr([num2str(i)]);
end
%leg=legend(legendcell)
leg=legend(elnames,'Interpreter','latex');
leg=legend(elnames,'Interpreter','latex');
ax=gca;
%title('$ \Gamma ^{\beta} $','Interpreter','latex');
xlabel('$Distance\:(m)$','Interpreter','latex')
ylabel('$ M_k ^{\beta} \times u_k ^{\beta} $','Interpreter','latex' );
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);
savefig('gamma.fig')


a=figure;
hold on;box on;
for i=1:5
plot(GP',Gamma_eff(i,:));
legendcell(i)=cellstr([num2str(i)]);
end
%leg=legend(legendcell)
leg=legend(elnames,'Interpreter','latex');
leg=legend(elnames,'Interpreter','latex');
ax=gca;
%title('Gamma* liquid');
ylabel('$ \lambda \times M_k ^{\beta} \times u_k ^{\beta} $','Interpreter','latex' );
xlabel('$Distance\:(m)$','Interpreter','latex')
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);
savefig('labfact.fig')
savefig('gamma_eff.fig')


a=figure;
hold on;box on;
k=1
for i=1:5
plot((GP(1:end-1))',grad(i,:));
legendcell(i)=cellstr([num2str(i)]);
end
leg=legend(elnames,'Interpreter','latex');
leg=legend(elnames,'Interpreter','latex');
ax=gca;
%leg=legend(['C'],['Co'],['N'],['Ti'],['W']);
ylabel('$\nabla \mu _k$','Interpreter','latex');
xlabel('$Distance\:(m)$','Interpreter','latex')
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20);
savefig('mur_grad.fig')


% figure;
% hold on;box on;
% k=1
% for i=1:5
% plot((GP(1:end-1))',grad(i,:),(GP(1:end-1))',dumped_grad(i,:),'*');
% legendcell(i)=cellstr([num2str(i)]);
% end
% %leg=legend(legendcell)
% leg=legend(['C-calculated'],['C-dumped'],['Co-calculated'],['C-dumped'],...
%   ['N-calculated'],['N-dumped'],['Ti-calculated'],['Ti-dumped'],...
%   ['W-calculated'],['W-dumped']);
% title('$\Delta \mur$','Interpreter','latex');
% set(findall(gca, 'Type', 'Line'),'LineWidth',1);
% set(gca,'fontsize',20);
% savefig('mur_grad.fig')


a=figure;
hold on;box on;
for i=1:5
plot((GP(1:end-1))',J(i,:));
legendcell(i)=cellstr([num2str(i)]);
end
%leg=legend(legendcell)
leg=legend(elnames,'Interpreter','latex');
leg=legend(elnames,'Interpreter','latex');
ax=gca;
%title('J_k ^{\beta}');
ylabel('$J_k ^{\beta}$','Interpreter','latex');
xlabel('$Distance\:(m)$','Interpreter','latex')
set(findall(a, 'Type', 'Line'),'LineWidth',1);
set(ax,'fontsize',20)
%gca.TickLabelInterpreter='atex'
savefig('flux.fig')


% figure;
% hold on;box on;
% for i=1:5
% plot((GP(1:end-1))',J(i,:)./uf_liq(i,1:end-1));
% plot((GP(1:end-1))',J(i,:)./uf_liq(i,2:end),'*');
% %legendcell(i)=cellstr([num2str(i)]);
% end
% %leg=legend(legendcell)
% %leg=legend(elnames);
% leg=legend(['C-calculated'],['C-dumped'],['Co-calculated'],['C-dumped'],...
%   ['N-calculated'],['N-dumped'],['Ti-calculated'],['Ti-dumped'],...
%   ['W-calculated'],['W-dumped']);

% title('flux in the liquid / u-fraction in the liquid');
% set(findall(gca, 'Type', 'Line'),'LineWidth',1);
% set(gca,'fontsize',20);
% savefig('gamma.fig')
% savefig('flux_over_ufraction.fig')
