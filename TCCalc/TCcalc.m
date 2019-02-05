function [mf_tot,chp,vpv,npm,mf_el_in_Ph,mob_in_Ph,phasenames] = TCcalc(folder_path,poly3_path,mole_fractions,element_names,phase_names,ndt)

nel=size(element_names,2);
nph=size(phase_names,2);
ngp=size(mole_fractions,1)/nel/ndt;
ncell=size(mole_fractions,1)/nel;
for phidx=1:nph
  zDic = contains(phase_names(phidx),'ZZDICTRA_GHOST','IgnoreCase',true);
  if ~zDic
    str_temp=char(phase_names(phidx));
    k = strfind(str_temp,'#');
    phasenames(1,phidx) = cellstr(eraseBetween(str_temp,k,strlength(str_temp)));
  end
end
nph=size(phasenames,2);
for elidx=1:nel
  x_names(elidx)=cellstr([ 'x(' element_names{elidx} ')']);
end
%%
tc_init_root;
tc_read_poly3_file(poly3_path);
for cellidx=1:ncell
  
  mf(1:nel)=mole_fractions((cellidx-1)*nel+1:(cellidx)*nel);
  for elidx=1:nel-1
    tctoolbox('tc_set_condition',char(x_names(elidx)), mf(elidx));
  end
  tc_compute_equilibrium;
  %%
  for elidx=1:nel
    %chp((cellidx-1)*nel+elidx)= tc_get_value(char(['mur(' char(element_names(elidx)) ')']));
    chp(elidx,cellidx)=tc_get_value(char(['mur(' char(element_names(elidx)) ')']));
    mf_tot(elidx,cellidx)=tc_get_value(char(['x(' char(element_names(elidx)) ')']));
  end
  for phidx=1:nph
    %npm((cellidx-1)*nph+phidx)= tc_get_value(char(['npm(' char(phasenames(phidx)) ')']));
    %vpv((cellidx-1)*nph+phidx)= tc_get_value(char(['vpv(' char(phasenames(phidx)) ')']))
    npm(phidx,cellidx)= tc_get_value(char(['npm(' char(phasenames(phidx)) ')']));
    vpv(phidx,cellidx)= tc_get_value(char(['vpv(' char(phasenames(phidx)) ')']));
    for elidx=1: nel
      mf_el_in_Ph(cellidx,phidx,elidx) = tc_get_value(char(['X(' char(phasenames(phidx)) ',' char(element_names(elidx)) ')']));
      mob_in_Ph(cellidx,phidx,elidx)   = tc_get_value(char(['M(' char(phasenames(phidx)) ',' char(element_names(elidx)) ')']));
    end
  end
end
end




