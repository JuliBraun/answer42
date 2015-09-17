function [dataSweepVals,Matdata,zHeader,dataProps,dataTimes,dataTemps] = formatLIData2Mat(tdmsData)
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

min_points=1e6;
ind=1;
while 1 %Go through the Lock-In Demodulators
    loc=find(ismember(zHeader,strcat('LI',num2str(ind),'_timestamp')));
    if loc
        for indi=1:sweepslen
            % Substract first value to start time at beginning of
            % measurement
            tmp=sweeps(indi).(zHeader{loc}).data-sweeps(indi).(zHeader{loc}).data(1);
            % Divide by Clockbase for values in seconds
            sweeps(indi).(strcat('LI',num2str(ind),'_timestamp')).data=tmp./210000000;            
            % Calculate R and Theta
            sweeps(indi).(strcat('LI',num2str(ind),'_R')).data=sqrt(sweeps(indi).(strcat('LI',num2str(ind),'_X')).data.^2+sweeps(indi).(strcat('LI',num2str(ind),'_Y')).data.^2);
            sweeps(indi).(strcat('LI',num2str(ind),'_Theta')).data=atan(sweeps(indi).(strcat('LI',num2str(ind),'_Y')).data./sweeps(indi).(strcat('LI',num2str(ind),'_X')).data);
%             % Take the mean of R and Theta for times around the
%             % B_timestamps
%             for indj=1:length(sweeps(indi).B_timestamp.data)
%                 sweeps(indi).(strcat('LI',num2str(ind),'_R')).data(indj)=mean(Rtmp(find(tmp>sweeps(indi).B_timestamp.data(indj)-0.5*sp & tmp<sweeps(indi).B_timestamp.data(indj)+0.5*sp)));
%                 sweeps(indi).(strcat('LI',num2str(ind),'_Theta')).data(indj)=mean(Thtmp(find(tmp>sweeps(indi).B_timestamp.data(indj)-0.5*sp & tmp<sweeps(indi).B_timestamp.data(indj)+0.5*sp)));
%             end
            points=length(sweeps(indi).(strcat('LI',num2str(ind),'_R')).data);
            if points<min_points
                min_points=points;
            end
        end
    else
        DemodNumber=ind-1;
        break       
    end
    ind=ind+1;
end

ind=1;
while 1 %Go through the Lock-In AuxIns
    loc=find(ismember(zHeader,strcat('AuxIn_',num2str(ind-1))));
    if loc
    else
        AuxNumber=ind-1;
        break
    end
    ind = ind+1;
end

% If the ycase sweeps the magnet (legacy case of one channel per sweep
% part)
sw0=find(ismember(zHeader,'Sweep0'));
if sw0
    for ind=1:size(sweeps,2)
        %% First create a single B_sweep channel together with a B_timestamp channel
        indi=0;
        swtmp=find(ismember(zHeader,strcat('Sweep',num2str(indi))));
        sweeps(ind).B_sweep.data=[];
        while swtmp
            lastind=length(sweeps(ind).B_sweep.data);
            sweeps(ind).B_sweep.Props.(strcat('Timestamp',num2str(indi)))=datetime(sweeps(ind).(zHeader{swtmp}).Props.Timestamp,'InputFormat','dd-MMM-y HH:mm:ss:SSS');
            sweeps(ind).B_sweep.data=[sweeps(ind).B_sweep.data,sweeps(ind).(zHeader{swtmp}).data];
            
            indi=indi+1;
            swtmp=find(ismember(zHeader,strcat('Sweep',num2str(indi))));
        end
        mtime=etime(datevec(sweeps(ind).B_sweep.Props.(strcat('Timestamp',num2str(indi-1)))),datevec(sweeps(ind).B_sweep.Props.Timestamp0));
        sp = mtime/lastind;
        sweeps(ind).B_timestamp.data=(1:length(sweeps(ind).B_sweep.data)).*sp;
    end
    % Use xtHeader and xHeader for different cases
    xtHeader='B_timestamp';
    xHeader='B_sweep';
end
clear sw0 swtmp sw3 lastind mtime

%If the ycase sweeps the magnet
Bsw=find(ismember(zHeader,'B_sweep'));
if Bsw
end
clear Bsw

%If the ycase sweeps the THz frequency
Freq=find(ismember(zHeader,'Frequency__GHz__up'));
if Freq
    xHeader='THz_Frequency';
    xtHeader='THz_time';
    for ind=1:sweepslen
        sweeps(ind).(xHeader).data=[sweeps(ind).Frequency__GHz__up.data,sweeps(ind).Frequency__GHz__down.data];
        if (dataProps.XCaseName=='IPS120 B-Sweep' & ind~=1)
            sweeps(ind).(xtHeader).data=30+(dataProps.Sweep_Step./dataProps.XCaseNumParSweep_rate__T_min_)*60+(1:length(sweeps(ind).(xHeader).data)).*(dataProps.YCaseNumParTHz_Integration_time__ms_+5).*0.001;
        else
            sweeps(ind).(xtHeader).data=30+(1:length(sweeps(ind).(xHeader).data)).*(dataProps.YCaseNumParTHz_Integration_time__ms_+5).*0.001;
        end
    end
end
clear Freq

clear zHeader
Matdata=nan(sweepslen,min_points,2*DemodNumber+1+AuxNumber);
for ind = 1:sweepslen
    Matdata(ind,:,1)=interp1(sweeps(ind).(xtHeader).data,sweeps(ind).(xHeader).data,sweeps(ind).LI1_timestamp.data(1:min_points));
end
zHeader{1}=xHeader;
for ind=1:DemodNumber
    tmp=horzcat(sweeps(:).(strcat('LI',num2str(ind),'_R')));
    for i=1:sweepslen
        tmp1=tmp(i).data;
        tmp(i).data=tmp1(1,1:min_points);
    end;
    Matdata(:,:,ind*2)=vertcat(tmp.data);
    zHeader{ind*2}=strcat('LI',num2str(ind),'_R');
    tmp=horzcat(sweeps(:).(strcat('LI',num2str(ind),'_Theta')));
    for i=1:sweepslen
        tmp1=tmp(i).data;
        tmp(i).data=tmp1(1,1:min_points);
    end;
    Matdata(:,:,ind*2+1)=vertcat(tmp.data);
    zHeader{ind*2+1}=strcat('LI',num2str(ind),'_Theta');
end
for ind=1:AuxNumber
    tmp=horzcat(sweeps(:).(strcat('AuxIn_',num2str(ind-1))));
    for i=1:sweepslen
        tmp1=tmp(i).data;
        tmp(i).data=tmp1(1,1:min_points);
    end;
    Matdata(:,:,2*DemodNumber+1+ind)=vertcat(tmp.data);
    zHeader{2*DemodNumber+1+ind}=strcat('AuxIn_',num2str(ind-1));
end
    
