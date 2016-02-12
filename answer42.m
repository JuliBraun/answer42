function varargout = answer42(varargin)
% ANSWER42 MATLAB code for answer42.fig
%      ANSWER42, by itself, creates a new ANSWER42 or raises the existing
%      singleton*.
%
%      H = ANSWER42 returns the handle to a new ANSWER42 or the handle to
%      the existing singleton*.
%
%      ANSWER42('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANSWER42.M with the given input arguments.
%
%      ANSWER42('Property','Value',...) creates a new ANSWER42 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before answer42_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to answer42_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help answer42

% Last Modified by GUIDE v2.5 24-Nov-2014 11:50:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @answer42_OpeningFcn, ...
                   'gui_OutputFcn',  @answer42_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before answer42 is made visible.
function answer42_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
if ~isdeployed
    %rootPath='/media/julian/AGScheer/jbraun/Software/WMI/answer43/libs/';
    rootPath=fullfile(pwd,'libs',filesep);
    subscriptRoot='/media/julian/AGScheer/jbraun/Software/WMI/answer43/subscripts';
    if isempty(strfind(path,rootPath))
        addpath(genpath(rootPath));
    end;
    if isempty(strfind(path,subscriptRoot))
        addpath(genpath(subscriptRoot));
    end;
end;
%read all function defs
lib = populatelib(subscriptRoot);

%get actual caseList (deprecated...)
xCaseRoot='/media/julian/e0b48436-b77c-4909-bcad-e069a23c89ac/home/julian/Dokumente/Software/WMI/DeepThought/case folder/X Cases';
yCaseRoot='/media/julian/e0b48436-b77c-4909-bcad-e069a23c89ac/home/julian/Dokumente/Software/WMI/DeepThought/case folder/Y Cases';
try
    tmp=load('defaults.mat');
    startfolder=tmp.pathname;
catch
    startfolder=pwd;
end;
stdEvalCaseNbr=1;
myLib={getCases(xCaseRoot),getCases(yCaseRoot),...
    startfolder,lib,stdEvalCaseNbr};
setappdata(handles.fileNamePushButton,'UserData',myLib);
% Choose default command line output for answer42
%handles.output = hObject;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = answer42_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on selection change in evalFunctionPopupMenuLabel.
function evalFunctionPopupMenu_Callback(hObject, eventdata, handles)
lib=getappdata(handles.fileNamePushButton,'UserData');
myLib=getappdata(handles.fileNamePushButton,'UserData');
myLib{5}=get(handles.evalFunctionPopupMenu,'Value');
setappdata(handles.fileNamePushButton,'UserData',myLib);
updateFlags(handles,lib{4});
updateFlagEdit(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function evalFunctionPopupMenuLabel_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in flagsListBox.
function flagsListBox_Callback(hObject, eventdata, handles)
updateFlagEdit(handles);

% --- Executes during object creation, after setting all properties.
function flagsListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','None');
end

%
function flagTextEdit_Callback(hObject, eventdata, handles)    
    [plotname,evalname]=createFileNames(get(handles.fileName,'String'));
    changeFlag(handles,get(hObject,'String'),get(handles.flagsListBox,'Value'),...
        strcat(evalname,'caseconf.mat'));

% --- Executes during object creation, after setting all properties.
function flagTextEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','None');
end

% --- Executes on button press in flagValidRadioButton.
function flagValidRadioButton_Callback(hObject, eventdata, handles)


% --- Executes on button press in flagCheckBox.
function flagCheckBox_Callback(hObject, eventdata, handles)
    [plotname,evalname]=createFileNames(get(handles.fileName,'String'));
    changeFlag(handles,get(hObject,'Value'),get(handles.flagsListBox,'Value'),...
        strcat(evalname,'caseconf.mat'));


% --- Executes on button press in fileNamePushButton.
function fileNamePushButton_Callback(hObject, eventdata, handles)
loadFile(handles);
guidata(hObject,handles);

    
function data_Callback(hObject, eventdata, handles)
runEvaluation(handles,hObject);
    

% --- Executes when filePanel is resized.
function filePanel_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to filePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when evaluationPanel is resized.
function evaluationPanel_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to evaluationPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes when plotPanel is resized.
%content top to bottom:
    %evalFunctionPopupMenuLabel 40.2 1.6
    %evalFunctionPopupMenuLabel 40.2 1.6
    %flagsListBoxLabel 40.2 1.6
    %flagsListBox 40.2 scales
    %flagTextEdit
    %flagCheckBox/writePPTX
    %data/flagValidRadioButton
    %statusTextEdit
%only flagbox should scale in y
pos=get(handles.evaluationPanel,'Position');
width=40.2;
oneLineHeight=1.6;
topy=pos(4)-oneLineHeight;
set(handles.evalFunctionPopupMenuLabel,'Position',...
    [0,topy-oneLineHeight,...
    width,oneLineHeight]);
set(handles.evalFunctionPopupMenu,'Position',...
    [0,topy-2*oneLineHeight,...
    width,oneLineHeight]);
set(handles.flagsListBoxLabel,'Position',...
    [0,topy-3*oneLineHeight,...
    width,oneLineHeight]);
%scales in y
set(handles.flagsListBox,'Position',...
    [0,pos(2)+7*oneLineHeight,...
    width,topy-10*oneLineHeight]);
set(handles.flagTextEdit,'Position',...
    [0,pos(2)+5*oneLineHeight,...
    width,2*oneLineHeight]);
set(handles.flagCheckBox,'Position',...
    [0,pos(2)+4*oneLineHeight,...
    width/2,oneLineHeight]);
set(handles.writePPTX,'Position',...
    [width/2,pos(2)+4*oneLineHeight,...
    width,oneLineHeight]);
set(handles.data,'Position',...
    [0,pos(2)+3*oneLineHeight,...
    width/2,oneLineHeight]);
set(handles.flagValidRadioButton,'Position',...
    [width/2,pos(2)+3*oneLineHeight,...
    width,oneLineHeight]);
set(handles.statusTextEdit,'Position',...
    [0,pos(2),...
    width,3*oneLineHeight]);

function plotPanel_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to plotPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%pos: user position and size of the window
pos=get(hObject,'Position');
%format [x0,y0,width,height) 
FileMenuPos=[43.5,25];
EvalMenuPos=[43.5,30];
TDMSCommentPos=[50,15];
TDMSPropsPos=[50,20];

xmargin=0.2;
ymargin=0.2;
minPlotPanelSize=[75,55];
%minimum x
if pos(3) < TDMSCommentPos(1)+EvalMenuPos(1)+minPlotPanelSize(1)
    set(hObject,'Position',[pos(1),pos(2),TDMSCommentPos(1)+EvalMenuPos(1)+minPlotPanelSize(1),pos(4)]);
    pos(3)=TDMSCommentPos(1)+EvalMenuPos(1)+minPlotPanelSize(1);
end; 
%minimum y
if pos(4) < minPlotPanelSize(2)
    set(hObject,'Position',[pos(1),pos(2),pos(3),minPlotPanelSize(2)]);
    pos(4)=minPlotPanelSize(2);
end;  
%from left to right, top to bottom
%plotpanel: scales at x and y, borders at x: TDMScomment and props 
set(handles.plotPanel,'Position',...
    [xmargin,ymargin,...
    (pos(3)-TDMSCommentPos(1)-FileMenuPos(1)-xmargin),pos(4)-ymargin]);
%TDMScomment:
set(handles.TDMS_comment,'Position',...
    [pos(3)-FileMenuPos(1)-TDMSCommentPos(1),pos(4)-TDMSCommentPos(2),...
    TDMSCommentPos(1)-xmargin,TDMSCommentPos(2)-ymargin]);
%TDMSprops: scale in y
set(handles.TDMS_props,'Position',...
    [pos(3)-FileMenuPos(1)-TDMSPropsPos(1),ymargin,...
    TDMSPropsPos(1)-xmargin,pos(4)-TDMSCommentPos(2)-ymargin]);
%filepanel:
set(handles.filePanel,'Position',...
    [pos(3)-FileMenuPos(1),pos(4)-FileMenuPos(2),...
    FileMenuPos(1)-xmargin,FileMenuPos(2)-ymargin]);
%evalpanel: scale in y
set(handles.evaluationPanel,'Position',...
    [pos(3)-EvalMenuPos(1),ymargin,...
    EvalMenuPos(1)-xmargin,pos(4)-FileMenuPos(2)-ymargin]);
evaluationPanel_ResizeFcn(handles.evaluationPanel, eventdata, handles);



function statusTextEdit_Callback(hObject, eventdata, handles)
% hObject    handle to statusTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of statusTextEdit as text
%        str2double(get(hObject,'String')) returns contents of statusTextEdit as a double

% --- Executes during object creation, after setting all properties.
function statusTextEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statusTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a None background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in writePPTX.
function writePPTX_Callback(hObject, eventdata, handles)
% hObject    handle to writePPTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of writePPTX


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over statusTextEdit.
function statusTextEdit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to statusTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function evalFunctionPopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to evalFunctionPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
