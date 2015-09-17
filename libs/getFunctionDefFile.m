function functionDefs = getFunctionDefFile(subscriptRoot,functionNames)
readKey={...
    'application','yCases','yCaseNames','','';...
    'application','yCases','exceptXCase','','';...
    'flags','edit','editNames','','';...
    'flags','edit','types','','';...
    'flags','check','checkNames','','';...
    'flags','edit','lowerLimits','','';...
    'flags','edit','upperLimits','','';...
    'flags','edit','editDefaults','','';...
    'flags','check','checkDefaults','i',0};
for ii=1:size(functionNames,1)
    iniFileName=fullfile(subscriptRoot,functionNames{ii},'configuration.def');
    functionDefs{ii,1}=inifile(iniFileName,'read',readKey);
    for jj=1:8
        functionDefs{ii,1}{jj,1}=strsplit(functionDefs{ii,1}{jj,1},';');
    end;
end;
end