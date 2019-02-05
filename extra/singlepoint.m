function [v,vpv,vm,vmtot]=singlepoint(elnames,phnamesTC,x,T,P,N,dtbs)

  sel =[];
  for i = 1 : size(elnames,2)
    Xi_names(i) = cellstr([ 'X(' elnames{i} ')']);
    if i==1
      sel = strcat(sel,elnames{i});
    else
      sel = strcat(sel, {' '}, elnames{i});
    end
  end
  phs =[];
  for i = 1 : size(phnamesTC,2)
    if i==1
      phs = strcat(phs,phnamesTC{i});
    else
      phs = strcat(phs, {' '}, phnamesTC{i});
    end
  end   
  %% Initiate the TC system
    tic
    tc_init_root;
  %% Choose database %dtbs='TCFE9'; %tc_open_database('TCFE9');
  %% Select elements and phases and retrieve data
  tc_define_system(dtbs,sel,{'*'},phs);
  %     [aa,bb]=tc_list_component;
  %         pr=[];
  %         for i = 1 : size(bb,1)
  %             pr = [pr ' ' char(bb{i})];
  %         end
  %         sprintf('%s', ['Components = ' pr]) 
  %     [aa,bb]=tc_list_phase;
  %         pr=[];
  %         for i = 1 : size(bb,1)
  %             pr = [pr ' ' char(bb{i})];
  %         end
  %         sprintf('%s', ['Phases = ' pr])
  tc_get_data;
  %% set conditions 
  tctoolbox('tc_set_condition', 'n', N);
  tctoolbox('tc_set_condition', 'p', P);%101325
  tctoolbox('tc_set_condition', 't', T);
  for i = 1: (size(Xi_names,2)-1)
  tctoolbox('tc_set_condition',char(Xi_names(i)), x(i,1));
  %[a,b]=tc_error;
  end
  %     [aa,bb] = tc_list_conditions;
  %         pr=[];
  %         for i = 1 : size(bb,1)
  %             pr = [pr ' ' char(bb{i})];
  %         end
  %         sprintf('%s', ['Conditions = ' pr ] )
  [aa] = tc_degrees_of_freedom;
  sprintf('%s', ['DOF = ' num2str(aa)] )
  %% compute equilibrium
  tc_compute_equilibrium;
  toc
  %% Read volume data
  for i = 1 :  size(phnamesTC,2)
  vpv(i) = tc_get_value(char(['vpv(' char(phnamesTC(i)) ')']) );
  v(i) = tc_get_value(char(['v(' char(phnamesTC(i)) ')' ]));
  vm(i) = tc_get_value(char(['vm(' char(phnamesTC(i)) ')' ]));
  end
  vmtot = sum(v);  
end