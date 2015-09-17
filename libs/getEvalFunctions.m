function [functionNames, functionDefinitions,lastchange] = getEvalFunctions(subscriptRoot)
%FILEFUNCTIONS retrieves names of evaluation functions and info on which
%cases they do apply

    %maybe add fucntion that test if path works and else goes to file3 or 4

    %list contents of subscript folder
    listing=dir(subscriptRoot);
    %initialize indicator
    functionNamesIt=1;
    %first two are '.' and '..'
    for it=3:size(listing,1)
        %check if entry is folder. True-> add to function names, get
        %function definitions and add them to function definitions
        if listing(it).isdir && (exist(fullfile(subscriptRoot,listing(it).name,'configuration.def'),'file')~=0)
            functionNames(functionNamesIt,1)={listing(it).name};
            lastchange(functionNamesIt,1)={listing(it).date};
            functionNamesIt = functionNamesIt+1;
        end;
    end;
    functionDefinitions=getFunctionDefFile(subscriptRoot,functionNames);
end
