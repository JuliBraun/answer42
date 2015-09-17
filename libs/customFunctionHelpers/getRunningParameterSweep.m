function [rpData,rpValues] = getRunningParameterSweep(filename,handles,myflags)
%loads all runpars in the folder starting from the current runpar in a huge
%array

sendStatus(handles,'retrieving run par data');
%% find out which time string to start at (in filename)
[mPath,runparname,ext]=filepaths(filename);
runparname=strsplit(runparname,'_');
mStartdate=runparname{1};

%% get list of all files in folder
%mPath=strjoin(splitstr(1:end-3),'\');
%mRunpars=dir(strcat(mPath,'\Raw\*.tdms'));
mRunpars=dir(fullfile(mPath,'*.tdms'));
mRunpars={mRunpars.name};

%% iterate through folder to get list of all filenames to load (in runparpaths)
runparpaths={};
runparIt=0;
for ii=1:numel(mRunpars)
    mTmpstr=strsplit(mRunpars{ii},'_');
    if str2num(mTmpstr{1})>=str2num(mStartdate)
        mTmpstr=strsplit(char(mTmpstr{3}),'.');
        mTmpstr=mTmpstr{1};
        if str2num(mTmpstr(3:end))>=runparIt
            %runparpaths{runparIt+1}=strcat(mPath,'\Raw\',mRunpars{ii});
            runparpaths{runparIt+1}=fullfile(mPath,mRunpars{ii});
            runparIt=runparIt+1;
        else
            break;
        end;
    end;
end;

%% get array dimensions from first runpar
[~,z,~,dataprops,~,~]=formatData2Mat(getDataFromTdms(runparpaths{1}));

rpData=nan([size(z,1) size(z,2) size(z,3) numel(runparpaths)]);
rpData(:,:,:,1)=z(:,:,:);

rpValues=nan(numel(runparpaths),1);
rpValues(1)=dataprops.RunPar0Value;

%% iterate through rest
for ii=2:numel(runparpaths)
    try      
        sendStatus(handles,strcat('loading RP',num2str(ii)));
        [~,z,~,dataprops,~,~]=formatData2Mat(getDataFromTdms(runparpaths{ii},handles));

        rpData(:,:,:,ii)=z(:,:,:);

        rpValues(ii)=dataprops.RunPar0Value;
    catch
        % in case measurements are still running last file will be corrupt
        rpData=rpData(:,:,:,1:ii-1);
        rpValues=rpValues(1:ii-1);
        break;
    end;
end;
sendStatus(handles,'runpars loaded!');

end