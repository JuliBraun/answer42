function [dataSweepVals,matlabdata,zHeader,dataProps,dataTimes,dataTemps] = formatData2Mat(tdmsdata)
%format complicated struct in easy to use matlab array

%use horzcat to avoid for loops
sweeps=struct2cell(tdmsdata);
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
if strcmp(dataProps.YCaseName,'ZVA24 ExGen_JPA')
    for i=1:size(sweeps,2)
        tmp=sweeps(i).(zHeader{1}).data;
        tmp=tmp(1:size(tmp,2)/2);
        sweeps(i).(zHeader{1}).data=tmp;
    end   
end

if strcmp(dataProps.YCaseName,'ZVA24 ExGenJPA')
    for i=1:size(sweeps,2)
        tmp=sweeps(i).(zHeader{1}).data;
        tmp=tmp(1:size(tmp,2)/2);
        sweeps(i).(zHeader{1}).data=tmp;
    end   
end
 tmp=horzcat(sweeps(:).(zHeader{1}));
sweepslen=length(dataSweepVals);
min_points=10^6;
for i=1:sweepslen
column=[tmp(i).data];
points=length(column);
    if points < min_points
        min_points = points;
    end;
end;
 for i=1:sweepslen
    tmp1=tmp(i).data;
    tmp(i).data=tmp1(1,1:min_points);
 end;



tmp=vertcat(tmp.data);
matlabdata=nan(size(tmp,1),size(tmp,2),size(zHeader,1));
for ii=1:size(zHeader,1)
    tmp=horzcat(sweeps(:).(zHeader{ii}));
    for i=1:sweepslen
        tmp1=tmp(i).data;
        tmp(i).data=tmp1(1,1:min_points);
    end;
    if size(vertcat(tmp.data),1)==size(matlabdata(:,:,ii),1)
         matlabdata(:,:,ii)=vertcat(tmp.data);
    else
        matlabdata=matlabdata(:,:,1:ii-1);
        break;
    end;
end