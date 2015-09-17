function [ output_args ] = updateFlagEdit( handles )
%UPDATEFLAGEDIT Summary of this function goes here
%   Detailed explanation goes here
functionDef=getappdata(handles.evalFunctionPopupMenu,'UserData');
listIndex=get(handles.flagsListBox,'Value');
editsize=size(functionDef.editnames,2);
if listIndex <= editsize
    set(handles.flagTextEdit,'Visible','on');
    set(handles.flagCheckBox,'Visible','off');
    set(handles.flagTextEdit,'String',functionDef.editdefaults(listIndex));
else
    set(handles.flagTextEdit,'Visible','off');
    set(handles.flagCheckBox,'Visible','on');
    set(handles.flagCheckBox,'Value',functionDef.checkdefaults(listIndex-editsize));
end;
end

