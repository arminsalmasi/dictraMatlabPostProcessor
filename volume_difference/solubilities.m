clc
clear variables
close all

load('C:\Users\salmasi\Documents\Mycodes\DICTRAMATLABPost\Normal\test\8-1D-F25-TCFE8-AIMD\fs_t_5297', 'chemps','dist',...
       'timeToPlot','elnames','phnamesPLOT','mole_fraction_in_phase','Mobility_in_phase','Vpv')
     

%dst= dist(2:end-1);
%chm = (chemps(:,2:end-1))';

dst= dist;
chm = chemps';
grad = diff(chm)./diff(dst)
for i=1: size(mole_fraction_in_phase,1)
  sum_sub(i) = sum(mole_fraction_in_phase(i,1,[2,4,5]));
  ufraction_in_liquid(i,1,:) = mole_fraction_in_phase(i,1,:)/sum_sub(i); 
  GAMMA(i,1,:) = ufraction_in_liquid(i,1,:).* Mobility_in_phase(i,1,:);
  effective_GAMMA(i,1,:) = Vpv(1,i).^3 .* ufraction_in_liquid(i,1,:).* Mobility_in_phase(i,1,:);
  if (i~=size(mole_fraction_in_phase,1))
    for k=1:5
      J(i,1,k)=GAMMA(i,1,k) * grad(i,k);
    end
  end
end










figure
hold on
plot(dst,GAMMA(:,1,1)) %dst,ufraction_in_liquid(:,1,1)
plot(dst,GAMMA(:,1,2) )%dst,ufraction_in_liquid(:,1,2),dst,
plot(dst,GAMMA(:,1,3) )%dst,ufraction_in_liquid(:,1,3),
plot(dst,GAMMA(:,1,4) )%dst,ufraction_in_liquid(:,1,4),
plot(dst,GAMMA(:,1,5) )%dst,ufraction_in_liquid(:,1,5),

figure
hold on
plot(dst,effective_GAMMA(:,1,1)) %dst,ufraction_in_liquid(:,1,1)
plot(dst,effective_GAMMA(:,1,2) )%dst,ufraction_in_liquid(:,1,2),dst,
plot(dst,effective_GAMMA(:,1,3) )%dst,ufraction_in_liquid(:,1,3),
plot(dst,effective_GAMMA(:,1,4) )%dst,ufraction_in_liquid(:,1,4),
plot(dst,effective_GAMMA(:,1,5) )%dst,ufraction_in_liquid(:,1,5),



figure
plot(dst,mole_fraction_in_phase(:,1,1))%dst,ufraction_in_liquid(:,1,1)
figure
plot(dst,mole_fraction_in_phase(:,1,2))%dst,ufraction_in_liquid(:,1,2),dst,
figure
plot(dst,mole_fraction_in_phase(:,1,3))%dst,ufraction_in_liquid(:,1,3),
figure
plot(dst,mole_fraction_in_phase(:,1,4))%dst,ufraction_in_liquid(:,1,4),
figure
plot(dst,mole_fraction_in_phase(:,1,5))%dst,ufraction_in_liquid(:,1,5),

figure
plot(dst,ufraction_in_liquid(:,1,1))
figure
plot(dst,ufraction_in_liquid(:,1,2))
figure
plot(dst,ufraction_in_liquid(:,1,3))
figure
plot(dst,ufraction_in_liquid(:,1,4))
figure
plot(dst,ufraction_in_liquid(:,1,5))


figure
plot(J(:,1,1)) %dst,ufraction_in_liquid(:,1,1)
figure
plot(J(:,1,2) )%dst,ufraction_in_liquid(:,1,2),dst,
figure
plot(J(:,1,3) )%dst,ufraction_in_liquid(:,1,3),
figure
plot(J(:,1,4) )%dst,ufraction_in_liquid(:,1,4),
figure
plot(J(:,1,5) )%dst,ufraction_in_liquid(:,1,5),