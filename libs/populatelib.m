function functionsLib =  populatelib(subscriptRoot)
[functionNames,functionDefs,lastchange]=getEvalFunctions(subscriptRoot);
for ii=1:size(functionNames,1)
    functionsLib(ii).name=functionNames(ii);
    functionsLib(ii).ycasenames=functionDefs{ii,1}{1};
    functionsLib(ii).exceptxcase=functionDefs{ii,1}{2};
    functionsLib(ii).editnames=functionDefs{ii,1}{3};
    functionsLib(ii).types=functionDefs{ii,1}{4};
    functionsLib(ii).checknames=functionDefs{ii,1}{5};
    functionsLib(ii).lowerlimits=functionDefs{ii,1}{6};
    functionsLib(ii).upperlimits=functionDefs{ii,1}{7};
    functionsLib(ii).editdefaults=functionDefs{ii,1}{8};
    functionsLib(ii).checkdefaults=functionDefs{ii,1}{9};
    functionsLib(ii).lastchange=lastchange(ii);
end;
try
    lastlib=load('defaults.mat','-mat');
    for ii=1:size(functionNames,1)
        if functionsLib(ii).lastchange<lastlib.lastchange
            functionsLib(ii).editdefaults=lastlib(ii).editdefaults;
            functionsLib(ii).checkdefaults=lastlib(ii).checkdefaults;
        end
    end
catch err
    %do nothing
end;
end