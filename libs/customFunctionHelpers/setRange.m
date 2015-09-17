function setRange(rangeArr,idx,straxis)

if strcmp(straxis,'z')
    if (~isnan(rangeArr(idx,1)))&&(~isnan(rangeArr(idx,2)))
        caxis(gca,[rangeArr(idx,1),rangeArr(idx,2)]);
    else
        caxis(gca,'auto');
    end;
end
if strcmp(straxis,'x')
    if (~isnan(rangeArr(idx,1)))&&(~isnan(rangeArr(idx,2)))
        xlim(gca,[rangeArr(idx,1),rangeArr(idx,2)]);
        axis manual
    else
        axis tight
        xlim(gca,'auto');
    end;
end
if strcmp(straxis,'y')
    if (~isnan(rangeArr(idx,1)))&&(~isnan(rangeArr(idx,2)))
        axis manual
        ylim(gca,[rangeArr(idx,1),rangeArr(idx,2)]);
    else
        axis tight
        ylim(gca,'auto');
    end;
end
end