function sendStatus(handles,text)
set(handles.statusTextEdit,'String',sprintf(text));
pause(0.001);
end