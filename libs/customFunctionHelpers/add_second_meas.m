function [caldata,caldataphase]=add_second_meas(freqs,sparameters,myflags,handles,subtractphasefitData,filename)
        try     
            calfile=load(char(getCustomParams(myflags,'CalibrationFile')),'-mat');
        catch err
            sendStatus(handles,'Calibration file cannot be loaded');
            caldata=0;
            return;
        end;            
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