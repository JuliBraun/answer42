function caseList = getCases(root)
tmp=dir(root);
tmp=tmp(3:end);
for i=1:size(tmp,1)
    caseList{i}=tmp(i).name;
end