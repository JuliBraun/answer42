function [dataSweepVals,THzdata,zHeader,dataProps,dataTimes,dataTemps] = formatTHzData2Mat(tdmsData)
%format complicated struct in easy to use matlab array

%use horzcat to avoid for loops
sweeps=struct2cell(tdmsData);
dataProps=sweeps{1};
% find broken file
dummy1st=length(fieldnames(sweeps{2}));
for i=2:length(sweeps)
    dummy=length(fieldnames(sweeps{i}));
    if dummy<dummy1st
       sweeps{i}=[];
    end
end
sweeps=sweeps(~cellfun(@isempty,sweeps));
    % find broken file ends
sweeps=horzcat(sweeps{2:end});
sweepprops=horzcat(sweeps.Props);
dataSweepVals=[sweepprops.Sweep_Value];
sweepslen=length(dataSweepVals);
dataTimes=[sweepprops.Time];
%todo write down temperature at each data point
dataTemps=0;
%sort sweeps
[dataSweepVals,xidx]=sort(dataSweepVals);
sweeps=sweeps(xidx);
dataTimes=dataTimes(xidx);

%get frequencies
zHeader=fieldnames(sweeps(1));
zHeader=zHeader(3:end);

indices=[find(ismember(zHeader,'Frequency__GHz__up')),find(ismember(zHeader,'THz_Photocurrent__nA__up')),find(ismember(zHeader,'Frequency__GHz__down')),find(ismember(zHeader,'THz_Photocurrent__nA__down'))];
THzHeader=zHeader(indices);
for indi=1:sweepslen
    for ind=1:length(THzHeader)
        sweeps(indi).(THzHeader{ind}).data(find(sweeps(indi).(THzHeader{ind}).data,1,'last')+1:end)=[];
    end
end

minpoints=length(sweeps(1).(THzHeader{1}).data);
for ind=1:sweepslen
    for indi=1:length(THzHeader)
        minpoints=min(minpoints,length(sweeps(ind).(THzHeader{indi}).data));
    end
end

%tmp=sweeps(1).(THzHeader{1}).data;
THzdata=nan(sweepslen,minpoints,length(indices));
for ii=1:length(indices)
    tmp=horzcat(sweeps(:).(THzHeader{ii}));
    for i=1:sweepslen
        tmp1=tmp(i).data;
        tmp(i).data=tmp1(1,1:minpoints);
    end
    if size(vertcat(tmp.data),1)==size(THzdata(:,:,ii),1)
         THzdata(:,:,ii)=vertcat(tmp.data);
    else
        THzdata=THzdata(:,:,1:ii-1);
        break;
    end;
end

