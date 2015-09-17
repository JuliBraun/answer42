function updateEvalFunctions(handles,functionDefs)
%UPDATEEVALFUNCTIONS Summary of this function goes here
%   Detailed explanation goes here
xCasePicked=get(handles.xCaseName,'String');
yCasePicked=get(handles.yCaseName,'String');
outp={''};
for ii=1:size(functionDefs,2)
    tmp=functionDefs(ii).ycasenames;
    tmp1=functionDefs(ii).exceptxcase; 
    if sum(strcmp(tmp,yCasePicked)) && ...
            ~sum(strcmp(tmp1,xCasePicked))
        outp{end+1}=char(functionDefs(ii).name);
    end;
end;
if size(outp,2)>1
    outp=outp(2:end);
else
    outp={};
end;
set(handles.evalFunctionPopupMenu,'String',outp);
end

