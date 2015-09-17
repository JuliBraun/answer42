function [caldata,caldataphase]=subtractCal(freqs,sparameters,myflags,handles,filename)
try
    calfile=load(char(getCustomParams(myflags,'CalibrationFile')),'-mat');
catch err
    sendStatus(handles,'Calibration file cannot be loaded');
    caldata=0;
    return;
end;
caldata=sparameters(:,:,1);
caldataphase=sparameters(:,:,2);

meancal=mean(calfile.sparameters,1);

calfreqs=calfile.freqs;

if size(meancal,2)==size(caldata,2)
    meancal2=meancal(:,:,1);
    meancal2ph=meancal(:,:,2);
else
    meancal2=zeros(size(sparameters,2),1);
    meancal2ph=zeros(size(sparameters,2),1);
    frdist=calfreqs(2,1)-calfreqs(1,1);
    for fridx=1:size(meancal2,1)
        meancalidx=find(calfreqs(:,1)>=freqs(fridx,1),1,'first');
        try
            if calfreqs(meancalidx)==freqs(fridx,1)
                meancal2(fridx)=meancal(1,meancalidx,1);
                meancal2ph(fridx)=meancal(1,meancalidx,2);
            else
                meancal2(fridx)=((freqs(fridx,1)-calfreqs(meancalidx))*meancal(1,meancalidx,1)+...
                    (-freqs(fridx,1)+calfreqs(meancalidx+1))*meancal(1,meancalidx+1,1))/frdist;
                meancal2ph(fridx)=((freqs(fridx,1)-calfreqs(meancalidx))*meancal(1,meancalidx,2)+...
                    (-freqs(fridx,1)+calfreqs(meancalidx+1))*meancal(1,meancalidx+1,2))/frdist;
            end;
        end;
    end;
end;

for calidx=1:size(sparameters,1)
    caldata(calidx,:,1)=sparameters(calidx,:,1)-meancal2(1,:);
    caldataphase(calidx,:,1)=sparameters(calidx,:,2)-meancal2ph(1,:);
end;


%phase unwrap
for ii=1:size(caldataphase,1)
    fitfunc=fit(freqs(:,1),caldataphase(ii,:)',fittype({'1','1e-9*x'}));
    fitvec=fitfunc(freqs(:,1));
    caldataphase(ii,:)=caldataphase(ii,:)-fitvec';
    
    for jj=1:size(caldataphase,2)
        while 1
            if caldataphase(ii,jj,1)>180
                caldataphase(ii,jj,1)=caldataphase(ii,jj,1)-360;
            elseif caldataphase(ii,jj,1)<-180
                caldataphase(ii,jj,1)=caldataphase(ii,jj,1)+360;
            end;
            if abs(caldataphase(ii,jj,1))<=180
                break;
            end;
        end;
    end;
end;

if 0
    caldata=sparameters;
    calfrqs=calfile.freqs(:,1);
    calspara=calfile.sparameters;
    %because xaxis for cals is additional average
    meancal=mean(calspara,1);
    for frqRangeIdx=1:size(freqs,2)
        for frqIdx=1:size(freqs,1)
            %look which idx is frq
            idx1=find(calfrqs>=freqs(frqIdx,frqRangeIdx));
            idx1=idx1(1);
            if calfrqs(idx1)==freqs(frqIdx,frqRangeIdx)
                caldata(:,frqIdx,:,frqRangeIdx)=sparameters(:,frqIdx,:,frqRangeIdx)-meancal(1,:,:,frqRangeIdx);
                continue;
            end
            if idx1>1
                idx0=idx1-1;
                max_sidx=size(meancal,3);
                for sidx=1:max_sidx
                    freqslope=(meancal(1,idx1,sidx,frqRangeIdx)-meancal(1,idx0,sidx,frqRangeIdx))/...
                        (calfrqs(idx1)-calfrqs(idx0));
                    for xidx=1:size(sparameters,1)
                        caldata(xidx,frqIdx,sidx,frqRangeIdx)=sparameters(xidx,frqIdx,sidx,frqRangeIdx)-...
                            meancal(1,idx0,sidx,frqRangeIdx)+...
                            freqslope*(freqs(frqIdx,frqRangeIdx)-calfrqs(idx0));
                    end;
                end;
            end;
        end;
    end;
    caldataphase=0;
    if getCustomParams(myflags,'Subtract Linear Phase Fit')
        caldataphase=subtractphasefitData;
        calspara=calfile.subtractphasefitData;
        meancal=calspara;%mean(calspara,1);
        for frqRangeIdx=1:size(freqs,2)
            for frqIdx=1:size(freqs,1)
                %look which idx is frq
                idx1=find(calfrqs>=freqs(frqIdx,frqRangeIdx));
                idx1=idx1(1);
                if calfrqs(idx1)==freqs(frqIdx,frqRangeIdx)
                    caldataphase(:,frqIdx,:,frqRangeIdx)=subtractphasefitData(:,frqIdx,:,frqRangeIdx)-meancal(1,:,:,frqRangeIdx);
                    continue;
                end
                if idx1>1
                    idx0=idx1-1;
                    max_sidx=size(meancal,3);
                    for sidx=1:max_sidx
                        freqslope=(meancal(1,idx1,sidx,frqRangeIdx)-meancal(1,idx0,sidx,frqRangeIdx))/...
                            (calfrqs(idx1)-calfrqs(idx0));
                        for xidx=1:size(sparameters,1)
                            caldataphase(xidx,frqIdx,sidx,frqRangeIdx)=subtractphasefitData(xidx,frqIdx,sidx,frqRangeIdx)-...
                                meancal(1,idx0,sidx,frqRangeIdx)+...
                                freqslope*(freqs(frqIdx,frqRangeIdx)-calfrqs(idx0));
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
if strcmp(filename,'=none')
    return;
end
sendStatus(handles,'saving case data...');
try
    save(filename,'caldataphase','-append');
    sendStatus(handles,'saving case data...\n done');
catch
    sendStatus(handles,'save error');
end
try
    save(filename,'caldata','-append');
catch
    sendStatus(handles,'save error');
end


end