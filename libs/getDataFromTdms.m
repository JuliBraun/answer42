function tdmsData = getDataFromTdms( fileName,handles )
    matlabFileName = strsplit(fileName,'.');
    matlabFileName{size(matlabFileName,2)}='mat';
    matlabFileName = strjoin(matlabFileName,'.');
    datematlab=0.;
    datetdms=dir(fileName);
    datetdms=datetdms.datenum;
    if exist(matlabFileName,'file')
        datematlab=dir(matlabFileName);
        datematlab=datematlab.datenum;
       if datematlab>=datetdms
            tdmsData = load(matlabFileName,'-mat');
            tdmsData = tdmsData.tdmsData;    
       else
           casestor=strsplit(fileName,'\');
           ending=casestor(end);
           ending=strjoin(ending);
           ending=strsplit(ending,'.');
           ending=ending(1);
           casestor=casestor(1:end-2);
           casestor=[casestor 'Analysis' ending 'casestorage.mat'];
           casestor=strjoin(casestor,'\');
           delete(casestor);
           
           sendStatus(handles,'TDMSfile loading...');
           [ tdmsData, ~ ] = TDMS_getStruct(fileName,handles);
           
           sendStatus(handles,'Saving as .mat...');
           save(matlabFileName,'tdmsData');
        end
    else
        sendStatus(handles,'TDMSfile loading...');
        [ tdmsData, ~ ] = TDMS_getStruct(fileName,handles);
        
        sendStatus(handles,'Saving as .mat...');
        save(matlabFileName,'tdmsData');
    end
end

