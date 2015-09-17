function plotIt = plotFindResFreq(selector,myflags,sparameters,numplots,xvalues,freqs,subtractavData,titles,caldata,xtitle,plotIt)

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
                ylabel('Transmission (dB)');
                xlabel('Frequency (GHz)');
            end
        end
end