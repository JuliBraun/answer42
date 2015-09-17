function rangeArr = readRangeStr(rangestr,numplots)
rangeArr=NaN(numplots,2);
try
    rangestr2=strsplit(rangestr,',');
    for ii=1:size(rangestr2,2)
        ranstr2=strsplit(rangestr2{ii},':');
        if str2double(ranstr2{2})<str2double(ranstr2{3})
            rangeArr(str2double(ranstr2{1}(4:end)),:)=[str2double(ranstr2{2}) ...
             str2double(ranstr2{3})];
        else
            rangeArr(str2double(ranstr2{1}(4:end)),:)=[str2double(ranstr2{3}) ...
             str2double(ranstr2{2})];
        end;
    end;
catch
end;
end