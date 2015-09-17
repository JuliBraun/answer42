function  loadFile(handles)

myLib=getappdata(handles.fileNamePushButton,'UserData');
[filename,pathname,filterindex] = uigetfile('*.tdms','choose input file',...
    char(myLib{3}));
if filename
    %         xmlinfo=getxmlinfo(pathname,filename,myLib{1},myLib{2});
    %         display(myLib{1});
    %         display(xmlinfo);
    save('defaults.mat','pathname','-append');
    myLib{3}=pathname;
    setappdata(handles.fileNamePushButton,'UserData',myLib);
    fullfilename=fullfile(pathname,filename);
    set(handles.fileName,'String',fullfilename);
    %         set(handles.xCaseName,'String',xmlinfo{1});
    %         set(handles.yCaseName,'String',xmlinfo{2});
    [plotname,evalname]=createFileNames(fullfilename);
    [~,~,~]=mkdir(evalname);
    
    %loading TDMS file
    
    sendStatus(handles,'starting getDataFromTDMS...');
    data=getDataFromTdms(fullfilename,handles);
    sendStatus(handles,'TDMSfile loaded');
    
    setappdata(handles.data,'UserData',data);
    setappdata(handles.fileName,'UserData',data.Props);
    
    set(handles.xCaseName,'String',data.Props.XCaseName);
    set(handles.yCaseName,'String',data.Props.YCaseName);
    
    %load default parameters of last open
    try
        tmp=load(fullfile(evalname,'caseconf.mat'));
    catch
        tmp=myLib{4};
    end;
try
    myLib{4}=compareFunctionDefs(myLib{4},tmp.functionDefs,handles);
end;
    try
        myLib{5}=tmp.lastEvalFunction;
    end;
    
    %load parameters last used (or default if none used)
    %sendStatus(handles,'unable to load default function parameters');
    
    setappdata(handles.fileNamePushButton,'UserData',myLib);
    set(handles.evalFunctionPopupMenu,'Value',myLib{5});
    updateEvalFunctions(handles,myLib{4});
    if updateFlags(handles,myLib{4})
        updateFlagEdit(handles);
    end;
    lastEvalFunction=get(handles.evalFunctionPopupMenu,'Value');
    functionDefs=myLib{4};
    lastchanged=clock();
    save(fullfile(evalname,'caseconf.mat'),'functionDefs','lastchanged','lastEvalFunction');
end;   
