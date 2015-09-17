function success = updateFlags(handles,functionDefs)
%UPDATEFLAGS Summary of this function goes here
%   Detailed explanation goes here

%find out which function is picked
try
    popupFunctionNames=cellstr(get(handles.evalFunctionPopupMenu,'String'));
    popupIdx=get(handles.evalFunctionPopupMenu,'Value');
    if popupIdx>size(popupFunctionNames,1)
        popupIdx=1;
        set(handles.evalFunctionPopupMenu,'Value',1);
    end;
    actualFunctionName=popupFunctionNames{popupIdx};
catch err
    sendStatus(handles,'no evaluation function for ycase found!');
    success=false;
    return;
end
tmp=horzcat(functionDefs(:).name);
functionDef=functionDefs(find(strcmp(actualFunctionName,tmp)));
flagStr=char({char(functionDef.editnames),char(functionDef.checknames)});
set(handles.flagsListBox,'String',flagStr);
setappdata(handles.evalFunctionPopupMenu,'UserData',functionDef);
success=true;
end
