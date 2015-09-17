function updatedFDefs = compareFunctionDefs(newFDefs,oldFDefs,handles)
%   this function looks a little bit complex but it just looks for same
%   entries and updates them. However it has to be general (in case new cases etc added)

%check if function configurations are valid
idxlist=ones(size(newFDefs,2),1);
for newNameIt=1:size(newFDefs,2)
    if numel(newFDefs(newNameIt).checknames)~=numel(newFDefs(newNameIt).checkdefaults)||...
         numel(newFDefs(newNameIt).editnames)~=numel(newFDefs(newNameIt).editdefaults)
        idxlist(newNameIt)=0;
        sendStatus(handles,char(strcat(newFDefs(newNameIt).name,' has errors in configuration.def')));
        pause(5);
    end;
end;

for newNameIt=1:size(newFDefs,2)
    if ~idxlist(newNameIt)
        continue;
    end;
    for oldNameIt=1:size(oldFDefs,2)
        %check if eval cases have the same name
        if strcmp(newFDefs(newNameIt).name,oldFDefs(oldNameIt).name)
            %check if edtdefname is the same
            for newEdtDefIt=1:numel(newFDefs(newNameIt).editnames)
                for oldEdtDefIt=1:numel(oldFDefs(oldNameIt).editnames)
                    if strcmp(newFDefs(newNameIt).editnames(newEdtDefIt),...
                            oldFDefs(oldNameIt).editnames(oldEdtDefIt))
                        newFDefs(newNameIt).editdefaults(newEdtDefIt)=...
                            oldFDefs(oldNameIt).editdefaults(oldEdtDefIt);
                    end
                end
            end
            %check if checkdefname is the same
            for newChkDefIt=1:numel(newFDefs(newNameIt).checknames)
                for oldChkDefIt=1:numel(oldFDefs(oldNameIt).checknames)
                    if strcmp(newFDefs(newNameIt).checknames(newChkDefIt),...
                            oldFDefs(oldNameIt).checknames(oldChkDefIt))
%                             display(newChkDefIt);
%                             display(newFDefs(newNameIt).checkdefaults(newChkDefIt));
%                             display(newFDefs(newNameIt).checknames(newChkDefIt));
                        newFDefs(newNameIt).checkdefaults(newChkDefIt)=...
                            oldFDefs(oldNameIt).checkdefaults(oldChkDefIt);
                    end
                end
            end
        end
    end;
end;

updatedFDefs=newFDefs;
end