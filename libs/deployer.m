%check network date
sourcepath='\\wmi\user\groups\Qubit\DeepThought\evaluation';
netlisting=dir(sourcepath);
netidx=0;
for ii=1:size(netlisting,1)
    display(netlisting(ii).name);
    if sum(strcmp(netlisting(ii).name,'answer42.exe'))
        netidx=ii;
    end;
end;

%check locale date
loclisting=dir(pwd);
lcoidx=0;
for ii=1:size(loclisting,1)
    if sum(strcmp(loclisting(ii).name,'answer42.exe'))
        locidx=ii;
    end;
end;
if netlisting(netidx).datenum>loclisting(locidx).datenum ...
        || locidx==0
    display('copy newer version to loc');
    copyfile(strcat(sourcepath,'\answer42.exe'),...
        strcat(pwd,'\answer42.exe'));
end;
%system('answer42.exe');    