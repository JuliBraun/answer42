function plotIt = plotProfile(selector,myflags,sparameters,numplots,xvalues,freqs,subtractavData,subtractphasefitData,titles,caldata,caldataphase,xtitle,plotIt)

if selector==0
    try
        xstr=num2str(getCustomParams(myflags,'Profile X Value'));
    catch
        xstr=getCustomParams(myflags,'Profile X Value');
    end
    
        profileXvalues=strsplit(xstr,':');
    for ii=1:size(sparameters,3)
        for jj=1:size(sparameters,4)
            [~,plotIt]=subplot42(numplots,plotIt);
            for pidx=1:length(profileXvalues)
                idx=find(xvalues>=str2num(profileXvalues{pidx}),1,'first');
                
                xlimits = [min(freqs(:,jj)./1E9); max(freqs(:,jj)./1E9)];
                if getCustomParams(myflags,'Subtract Calibration')
                    if mod(ii,2)==1
                        plot(freqs(:,jj)./1E9,caldata(idx,:,(ii+1)/2));
                        xlim(xlimits);
                    else
                        plot(freqs(:,jj)./1E9,caldataphase(idx,:,(ii)/2));
                        xlim(xlimits);
                    end;
                elseif getCustomParams(myflags,'Subtract Average') && (mod(ii,2)==1)
                    plot(freqs(:,jj)./1E9,subtractavData(idx,:,(ii+1)/2,jj));
                    xlim(xlimits);
                elseif getCustomParams(myflags,'Subtract Linear Phase Fit') && (mod(ii,2)==0)
                    plot(freqs(:,jj)./1E9,subtractphasefitData(idx,:,(ii)/2,jj));
                    xlim(xlimits);
                else
                    plot(freqs(:,jj)./1E9,sparameters(idx,:,ii,jj));
                    xlim(xlimits);
                end
                hold on
            end
            if mod(ii,2) == 1
                phStr = 'Mag';
            else
                phStr = 'Phase';
            end;
            title(strcat({'X Profile at '},num2str(xvalues(idx),4),{' of '},xtitle,{' '}, phStr));
%             title(strcat(strrep(titles{ii,jj},'_',' '),'X Profile'));
            ylabel('Transmission (dB)')
            xlabel('Frequency (GHz)');
        end
    end
else
    for jj=1:size(sparameters,4)
        ystr=getCustomParams(myflags,'Profile Y Value');
        profileYvalues=strsplit(ystr,':');
        for ii=1:size(sparameters,3)
            for pidx=1:length(profileYvalues)
                idx=find(freqs(:,jj)>=1e9.*str2num(profileYvalues{pidx}),1,'first');

                [~,plotIt]=subplot42(numplots,plotIt);
                if getCustomParams(myflags,'Subtract Calibration')
                    plot(xvalues,caldata(:,idx,ii,jj)');
                elseif getCustomParams(myflags,'Subtract Average') && (mod(ii,2)==1)
                    plot(xvalues,subtractavData(:,idx,(ii+1)/2,jj));
                elseif getCustomParams(myflags,'Subtract Linear Phase Fit') && (mod(ii,2)==0)
                    plot(xvalues,subtractphasefitData(:,idx,(ii)/2,jj));
                else
                    plot(xvalues,sparameters(:,idx,ii,jj)');
                end
                hold on
            end
            if mod(ii,2) == 1
                phStr = 'Mag';
            else
                phStr = 'Phase';
            end;
            title(strcat({'Y Profile at '},num2str(freqs(idx,jj),4),{' GHz'},{' '}, phStr));
            ylabel('Transmission (dB)')
            xlabel(xtitle);
        end
    end
end
end