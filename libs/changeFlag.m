function changeFlag(handles,value,idx,confname)
    functionDef=getappdata(handles.evalFunctionPopupMenu,'UserData');
    lastEvalFunction=get(handles.evalFunctionPopupMenu,'Value');
    myLib=getappdata(handles.fileNamePushButton,'UserData');
    functionDefs=myLib{4};
    editsize=size(functionDef.editnames,2);
    if idx <= editsize
        functionDef.editdefaults(idx)=value;
    else
        functionDef.checkdefaults(idx-editsize)=value;
    end;
    
    for ii=1:size(functionDefs,2)
        if strcmp(functionDefs(ii).name,functionDef.name)
            functionDefs(ii)=functionDef;
            break;
        end;
    end;
    myLib{4}=functionDefs;
    setappdata(handles.evalFunctionPopupMenu,'UserData',functionDef);
    setappdata(handles.fileNamePushButton,'UserData',myLib);
    save('defaults.mat','functionDefs','-append');
    lastchanged=clock();
    save(confname,'functionDefs','lastchanged','lastEvalFunction');
end