clear variables
close all
clc

%% Main
current_path= pwd ;
folder_name = uigetdir(current_path);
%% read profiles from file/ save in a .mat file
if exist([folder_name '\postDataTmp.mat'], 'file')
    choice = questdlg('Warning: file postDataTmp exist','warning','Overwrite', 'Use the old file', 'Overwrite');
        switch choice
            case 'Overwrite'
                readProfiles(folder_name,current_path);  
        end
else
    %warningMessage = sprintf()
    %uiwait(msgbox(warningMessage));
    readProfiles(folder_name,current_path);
end
    A='DONE'
    clear A;



%% Function read profile
function [] = readProfiles(folder_name,current_path)
    
%% read scalar quantities from static files
    
    load ([folder_name '\GEOMETRY.TXT' ],'-ascii'); 
    geo=GEOMETRY;
    clear GEOMETRY
    
    load ([folder_name '\NR_OF_EL.TXT' ],'-ascii'); 
    nel=NR_OF_EL;
    clear NR_OF_EL
    
    load ([folder_name '\NR_OF_PH.TXT' ],'-ascii'); 
    nph=NR_OF_PH;
    clear NR_OF_PH

    load ([folder_name '\NR_OF_CELLS.TXT' ],'-ascii');
    nce=NR_OF_CELLS;
    clear NR_OF_CELLS

    % read vectors from static files
    load ([folder_name '\SUBSTITUTIONAL.TXT' ],'-ascii');
    sub=SUBSTITUTIONAL;
    clear SUBSTITUTIONAL
    
    load ([folder_name '\EL_INDEX.TXT' ],'-ascii');
    elindex=EL_INDEX;
    clear EL_INDEX

    load ([folder_name '\PH_INDEX.TXT' ],'-ascii');
    phindex=PH_INDEX;
    clear PH_INDEX

    load ([folder_name '\PH_COMP_SET.TXT' ],'-ascii');
    compset=PH_COMP_SET;
    clear PH_COMP_SET

    [fid,msg]=fopen([folder_name '\EL_NAMES.TXT' ],'r');
    [val,count]=fread(fid);
    res=fclose(fid);
    elnames=cell(0);
    j=1;
    for i=1:nel
        k=j;
        ok=1;
        while ok==1
            k=k+1;
            if val(k)==13
                %ok=0;
                val(k)=[];
            end
            if val(k)==10
                ok=0;
            end
        end
        elnames{i}=char(val(j:k-1)');
        j=k+1;
    end
    
    [fid,msg]=fopen([folder_name '\PH_NAMES.TXT' ],'r');
    [val,count]=fread(fid);
    res=fclose(fid);
    phnames=cell(0);
    j=1;
    for i=1:nph
      k=j;
      ok=1;
      while ok==1
        k=k+1;
        if val(k)==13
          %ok=0;
          val(k)=[];
        end
        if val(k)==10
          ok=0;
        end
      end
      phnames{i}=char(val(j:k-1)');
      j=k+1;
    end

    %valeol1=val;
    %valeol2=val;
    %fid = fopen([folder_name '\PH_NAMES.TXT' ]);
    %phsCell = textscan(fid,'%s\n');
    %fclose(fid);
    %phsChar = char(phsCell{1}); 
    %phsStr = cellstr(phsChar); 
    
    phsStr = phnames';
    for i = 1: size(phsStr,1)
      temp1 = phsStr{i};
      temp2 = temp1;
      k1 = strfind(temp1,'#');
      k2 = strfind(temp2,'_');
      temp1= temp1(1:k1-1);
      temp2(k2)='-';
      phsStr1{i} = temp1;
      phsStr2{i} = temp2;
    end
    phnamesTC = phsStr1;
    phnamesPLOT = phsStr2;

    %load dynamic vectors from file
    load ([folder_name '\TIME.TXT']);
    load ([folder_name '\REGIONS_PER_CELL.TXT']);
    load ([folder_name '\MOLE_FRACTIONS.TXT']);
    load ([folder_name '\PHASE_FRACTIONS.TXT']);
    load ([folder_name '\VOLUMES_PER_REGION.TXT']);
    load ([folder_name '\PHASES_IN_REGION.TXT']);
    load ([folder_name '\BOUNDARIES.TXT']);
    load ([folder_name '\VOLUME_MIDPOINTS.TXT']);
    load ([folder_name '\INTERFACE_U_FRACTIONS.TXT']);
    load ([folder_name '\CHEMICAL_POTENTIALS.TXT']);
    
    plotVolFlg=0;
    if exist([folder_name '\MOLAR_VOLUME.TXT'], 'file')
      %[fid,msg]=fopen([folder_name '\MOLAR_VOLUME.TXT'],'r');
      %if (fid>0)
        %res=fclose(fid);
      load ([folder_name '\MOLAR_VOLUME.TXT']);
      plotVolFlg=1;
    end
    
    if exist([folder_name '\FLUXES.TXT'], 'file')
      %[fid,msg]=fopen([folder_name '\FLUXES.TXT'],'r');
      %if (fid>0)
        %res=fclose(fid);
      load([folder_name '\FLUXES.TXT']);
    end


    [fid,msg]=fopen([folder_name '\REGION_NAMES.TXT'],'r');
    [val,count]=fread(fid);
    res=fclose(fid);
    regnames=cell(0);
    j=1;
    k=1;
    for i=1:size(val,1)
        if (val(i)==10)||(val(i)==13)
            regnames{k}=char(val(j:i-1)');
            j=i+1;
            k=k+1;
        end
    end
    clear val

    % preprocess data

    ndt=size(TIME,1);

    regionlen=ones(1,nce);
    regionlist=cell(1,nce);
    m=1;
    for j=1:nce
        for k=1:REGIONS_PER_CELL(j)
            regionlist{k,j}=regnames{m};
            m=m+1;
        end
        regionlen(1,j)=REGIONS_PER_CELL(j);
    end
    if (ndt>1)
        for i=2:ndt
            for j=1:nce
                for k=1:REGIONS_PER_CELL((i-1)*nce+j)
                    p=1;
                    for n=1:regionlen(1,j)
                        if (strcmp(regionlist{n,j},regnames{m})==1)
                            p=0;
                        end
                    end
                    if (p==1)
                        regionlen(1,j)=regionlen(1,j)+1;
                        regionlist{regionlen(1,j),j}=regnames{m};
                    end
                    m=m+1;
                end
            end
        end
    end

    INTERFACE_X_FRACTIONS=zeros(size(INTERFACE_U_FRACTIONS,1),1);
    p=0;
    for i=1:ndt
        for j=1:nce
            if (REGIONS_PER_CELL((i-1)*nce+j)>1)
                for k=1:REGIONS_PER_CELL((i-1)*nce+j)-1
                    for m=1:2
                        sfoo=0.0;
                        for n=1:nel
                            sfoo=sfoo+INTERFACE_U_FRACTIONS(p+n+(m-1)*nel);
                        end
                        sfoo=1.0/sfoo;
                        for n=1:nel
                            INTERFACE_X_FRACTIONS(p+n+(m-1)*nel,1)=...
                                sfoo*INTERFACE_U_FRACTIONS(p+n+(m-1)*nel);
                        end
                    end
                    p=p+2*nel;
                end
            else
                INTERFACE_X_FRACTIONS(p+1)=0.0;
                p=p+1;
            end
        end
    end

    %Read Atmoic masses from text file
    atmDataTable=readtable([current_path '\atomicmass.txt']);
    atmNamesTable=atmDataTable(:,2);
    atmMassTable=atmDataTable(:,3);
    atmNames = table2array(atmNamesTable);
    atmMass = table2array(atmMassTable);
    atmNames=upper(atmNames);
    for i = 1 : nel
        a = find(contains(atmNames, char(elnames{i})));
        for j=1:size(a,1)
            if char(atmNames(a(j)))== char(elnames{i})
                M(i)=atmMass(a(j));
            end
        end
        clear a
    end
    Er1 = 'Error: Check end of file character in EL_NAMES.TXT and rerun.';
    if size(M,2)~=nel
        sprintf('%s', Er1)
    end
    
    save([folder_name '\postDataTmp.mat'], 'VOLUMES_PER_REGION',...
         'VOLUME_MIDPOINTS', 'MOLE_FRACTIONS', 'CHEMICAL_POTENTIALS',...
         'PHASE_FRACTIONS', 'nel', 'nph', 'TIME', 'ndt', 'M','elnames',...
         'phnames','phnamesPLOT', 'phnamesTC', 'plotVolFlg');

    clear variables
end

