function plotIt = plotSParas(xvalues,freqs,sparameters,titles,plotIt,numplots,caldata,subtractavData,caldataphase,subtractphasefitData,lorentzdata,myflags,xtitle)
% readRanges
xrange=readRangeStr(getCustomParams(myflags,'XRanges'),numplots);
yrange=readRangeStr(getCustomParams(myflags,'YRanges'),numplots);
zrange=readRangeStr(getCustomParams(myflags,'ZRanges'),numplots);
titles=strrep(titles,'_','.');
if length(xvalues) == 1                                                                 %plot line if only one sweep exists
    for ii=1:size(freqs,2)
        for jj=1:2:size(sparameters,3)
            [~,plotIt]=subplot42(numplots,plotIt);
            if getCustomParams(myflags,'Subtract Calibration')
                plot(freqs(:,ii)./1E9, caldata(:,:,jj,ii)');
                title(strcat(titles{jj,ii},'Calibration subtracted'));
            elseif getCustomParams(myflags,'Subtract Average')
                plot(freqs(:,ii)./1E9, subtractavData(:,:,ceil((jj+1)/2),ii)');
                title(strcat(titles{jj,ii},'Average subtracted'));
            else
                plot(freqs(:,ii)./1E9,sparameters(:,:,jj,ii)');
                title(titles{jj,ii});
            end
            setRange(xrange,plotIt-1,'x');
            setRange(yrange,plotIt-1,'y');
            setRange(zrange,plotIt-1,'z');
            ylabel('Transmission (dB)');
            xlabel('Frequency (GHz)');
        end
    end
    for ii=1:size(freqs,2)
        for jj=1:2:size(sparameters,3)
            [~,plotIt]=subplot42(numplots,plotIt);
            if getCustomParams(myflags,'Subtract Calibration')
                plot(freqs(:,ii)./1E9, caldataphase(:,:,jj,ii)');
                title(strcat(titles{jj,ii},'Calibration subtracted'));
            elseif getCustomParams(myflags,'Subtract Linear Phase Fit')
                plot(freqs(:,ii)./1E9, subtractphasefitData(:,:,ceil((jj+1)/2),ii)');
                title(strcat(titles{jj,ii},'lin. Phase fit subtracted'));
            else
                plot(freqs(:,ii)./1E9,sparameters(:,:,jj+1,ii)');
                title(titles{jj,ii});
            end
            setRange(xrange,plotIt-1,'x');
            setRange(yrange,plotIt-1,'y');
            setRange(zrange,plotIt-1,'z');
            ylabel('Phase (deg)');
            xlabel('Frequency (GHz)');
        end
    end
else
    for ii=1:size(freqs,2)                                                              %plot surface plots:
        for jj=1:2:size(sparameters,3)
            [~,plotIt]=subplot42(numplots,plotIt);
            %plot mags
            %ystep = (freqs(2,ii)-freqs(1,ii))/1E9/2;
            %ylimits = [min(freqs(:,ii)./1E9)-ystep; max(freqs(:,ii)./1E9)+ystep];
            %xstep = (xvalues(2)-xvalues(1))/2;
            %xlimits = [min(xvalues)-xstep max(xvalues)+xstep];
            if getCustomParams(myflags,'Subtract Calibration')
                plotsurf_zvaFrequencySweep( xvalues, freqs(:,ii)./1E9, caldata(:,:,jj,ii)',titles{jj,ii},xtitle);
            elseif getCustomParams(myflags,'Subtract Average')
                plotsurf_zvaFrequencySweep( xvalues, freqs(:,ii)./1E9, subtractavData(:,:,ceil((jj+1)/2),ii)',strcat(titles{jj,ii},' Av Subtracted'),xtitle);
            else
                plotsurf_zvaFrequencySweep( xvalues, freqs(:,ii)./1E9, sparameters(:,:,jj,ii)',titles{jj,ii},xtitle);
            end
            setRange(xrange,plotIt-1,'x');
            setRange(yrange,plotIt-1,'y');
            setRange(zrange,plotIt-1,'z');
            if getCustomParams(myflags,'Lorentz Peak fit') + getCustomParams(myflags,'Lorentz dip fit')%add lorentz fit data to plots if activated
                hold on;
                plot(xvalues,lorentzdata(:,7,ii)./1E9','b.','LineWidth',3,'color','r');
                plot(xvalues,lorentzdata(:,7,ii)./1E9'+(lorentzdata(:,8,ii))./2./1E9','b-','LineWidth',1,'color','r');
                plot(xvalues,lorentzdata(:,7,ii)./1E9'-(lorentzdata(:,8,ii))./2./1E9','b-','LineWidth',1,'color','r');
                %set(gca,'Children',[chH(end);chH(1:end-1)]);
                hold off;
            end
            if length(titles)==1
            else
            %plot phases
            [~,plotIt]=subplot42(numplots,plotIt);

            if getCustomParams(myflags,'Subtract Calibration')
                plotsurf_zvaFrequencySweep( xvalues, freqs(:,ii)./1E9, caldataphase(:,:,ceil((jj+1)/2),ii)',titles{jj,ii},xtitle);
            elseif getCustomParams(myflags,'Subtract Linear Phase Fit')
                plotsurf_zvaFrequencySweep( xvalues, freqs(:,ii)./1E9, subtractphasefitData(:,:,ceil((jj+1)/2),ii)',strcat(titles{jj+1,ii},' linFit Subtracted'),xtitle);
            else
                plotsurf_zvaFrequencySweep( xvalues, freqs(:,ii)./1E9, sparameters(:,:,jj+1,ii)',titles{jj+1,ii},xtitle);
            end
            setRange(xrange,plotIt-1,'x');
            setRange(yrange,plotIt-1,'y');
            setRange(zrange,plotIt-1,'z');
            end
        end;
    end
end
end