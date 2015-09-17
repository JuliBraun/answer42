function runEvaluation(handles,hObject)
    [plotname,evalname]=createFileNames(get(handles.fileName,'String'));
    delete(allchild(handles.plotPanel));
    %check if function need run par sweep

    evalContents=cellstr(get(handles.evalFunctionPopupMenu,'String'));
%     display(get(handles.evalFunctionPopupMenu,'Value'));
    myFunction=str2func(evalContents{get(handles.evalFunctionPopupMenu,'Value')});
    myFunction(handles.plotPanel,handles.data,handles.evalFunctionPopupMenu,...
        fullfile(evalname,'casestorage.mat'),handles,hObject);
    if get(handles.writePPTX,'Value')
        writeToPPTX(handles,plotname);
    end;