function subtractavdata=subtractAv(sparameters,filename,handles,myflags,xvalues)
%subtracts the average value of each line in flux
try
    avrange=getCustomParams(myflags,'Subtract Average Range');
    avrange=strsplit(avrange,':');
    avrange=[find(xvalues>=str2double(avrange{1}),1,'first')...
        find(xvalues>=str2double(avrange{2}),1,'first')];
catch
    avrange = [ 1 size(sparameters,1) ];
end;
if numel(avrange)~=2
    avrange=[ 1 size(sparameters,1) ];
end;
subtractavdata=repmat(1,[size(sparameters,1) size(sparameters,2) ceil(size(sparameters,3)/2) size(sparameters,4)]);
for ii=1:ceil(size(sparameters,3)/2)
    for jj=1:size(sparameters,4)
        subtractavdata(:,:,ii,jj)=bsxfun(@minus,sparameters(:,:,2*ii-1,jj),mean(sparameters(avrange(1):avrange(2),:,2*ii-1,jj)));
    end;
end;

sendStatus(handles,'saving case data...');
try
    save(filename,'subtractavData','-append');
    sendStatus(handles,'saving case data...\n done');
catch
    sendStatus(handles,'save error');
end

end