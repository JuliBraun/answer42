function flagVals = getCustomParams(flags,flagId)
%get function parameters from def file and user input
    for jj=1:size(flags.editnames,2)
        if strcmp(flags.editnames(jj),flagId)
            if strcmp(flags.types(jj),'s')
                flagVals=char(flags.editdefaults(jj));                             
            else
                flagVals=str2double(flags.editdefaults(jj));
            end
            continue;
        end
    end;
    for jj=1:size(flags.checknames,2)
        if strcmp(flags.checknames(jj),flagId)
            flagVals=flags.checkdefaults(jj);
            continue;
        end
    end;
end