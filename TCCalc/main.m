%% first run read profile script

clc
close all
folder_name='E:\Dropbox\KTH_PHD\Projects\GradientSintering\Results\1D-DICTRA-results-4-5-6-7-8-9-10-n2.5-TCFE-AIMD\10-Oxidation-accuracy\10-1D-F25-TCFE-AIMD-300gp-300um-Ox-gasBC-ACC5e2-def\'
poly_path='C:\Users\salmasi\Desktop\POLY.POLY3'
sub_list=[2,4,5]
current_path=pwd
tstp_test=500
ngp=size(MOLE_FRACTIONS,1)/nel/ndt
stlim=(tstp_test-1)*nel*ngp+1
endlim=(tstp_test)*nel*ngp

dumped_chp_temp=CHEMICAL_POTENTIALS(stlim:endlim);
dumped_chp = reshape(dumped_chp_temp,nel,ngp);

%% claculate values of inner grid points 
[mf_sys,chp,vpv,npm,mf_el_in_ph,mob_el_in_ph,phasenames]...
=TCcalc(folder_name,poly_path,MOLE_FRACTIONS(stlim:endlim),elnames,phnames,ndt);
nph=size(vpv,1);
%% calculate Boundries
%% calculate ufractions
for phidx=1:1
  for gpidx=1:ngp
    temp_array=mf_el_in_ph(gpidx,phidx,:);
    sub_sum=sum(temp_array(sub_list))
    uf_el_in_ph(gpidx,phidx,:)=temp_array(:)/sub_sum;
  end
end

for gpidx=1:ngp
  temp_array=mf_sys(:,gpidx)';
  sub_sum=sum(temp_array(sub_list))
  uf_sys(:,gpidx)=(temp_array(:)/sub_sum)';
end

%%
stlim=(tstp_test-1)*ngp+1
endlim=(tstp_test)*ngp
GP=VOLUME_MIDPOINTS(stlim:endlim);


temp_array=[];
temp_array(1:ngp,1:nel)=(mob_el_in_ph(:,1,:));
mob_el_in_liq=temp_array';

temp_array=[];
temp_array(1:ngp,1:nel)=uf_el_in_ph(:,1,:);
uf_liq=temp_array';



labfact = (vpv(1,:).^2.5 );
Gamma = mob_el_in_liq.* uf_liq;
Gamma_eff = labfact.*Gamma;

for elidx=1:nel
  grad(elidx,:)=diff(chp(elidx,:))./(diff(GP))';
  dumped_grad(elidx,:)=diff(dumped_chp(elidx,:))./(diff(GP))';
end
  

J=-(1/1e-5)*Gamma_eff(:,2:end).* grad;




%CB=cell_boundaries(stlim:endlim);
% for i= 1:ngp-1
%   r1 =(CB(1,i+1)-GP(1,i))  /(CB(1,i+1)-CB(1,i));
%   r2 =(GP(1,i+1)-CB(1,i+1))/(CB(1,i+2)-CB(1,i+1));
%   m_f_ElinLiq_InerCB(:,i) = m_f_ElinLiq(:,i) *r1 +m_f_ElinLiq(:,i+1)*r2;
%   m_f_ElinLiq_InerCB(:,i) = m_f_ElinLiq_InerCB(:,i) / sum(m_f_ElinLiq_InerCB(:,i));
%   vpv_liq_InerCB(:,i) = vpv(:,i) *r1 +vpv(:,i+1)*r2;
%   vpv_liq_InerCB(:,i) = vpv_liq_InerCB(:,i) / sum(vpv_liq_InerCB(:,i));
% end
% for i =1:nel
%   m_f_ElinLiq_CB(i,:)=[m_f_ElinLiq_InerCB(i,1) m_f_ElinLiq_InerCB(i,:) m_f_ElinLiq_InerCB(i,end)];
% end
% for i =1:nph-1
%   vpv_liq_CB(i,:)=[vpv_liq_InerCB(i,1) vpv_liq_InerCB(i,:) vpv_liq_InerCB(i,end)];
% end
% [m_f_Liq_CB,n1,chem_pot_CB,u_f_CB,n2,vpv1,npm1,Mob_ElinPh1] ...
%   =TCcalc(folder_name,'C:\Users\salmasi\Desktop\POLY.POLY3',m_f_ElinLiq_CB,[2,4,5],elnames,phnames);
% Chempot_BC=8.314*1723.15*log(1e-11);
% chem_pot_CB(1,3)=Chempot_BC;
