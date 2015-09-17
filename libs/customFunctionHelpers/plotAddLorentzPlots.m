function plotIt = plotAddLorentzPlots(plotIt,numplots,freqs,xvalues,lorentzdata,xtitle)
        %displays bandwidth, mean etc for each l fitted object        
        %for varying color
        colorarr={'b.','g.','k.','y.','m.','c.','r.'};
                xstep = (xvalues(2)-xvalues(1))/2;
                xlimits = [min(xvalues)-xstep max(xvalues)+xstep];        
        %FWHM
        [~,plotIt]=subplot42(numplots,plotIt);
        hold on;
        for magidx=1:size(freqs,2)
            plot(xvalues,lorentzdata(:,8,magidx)./1E6',colorarr{magidx},'LineWidth',3);
            xlabel(xtitle);
            xlim(xlimits);
            ylabel('Lorentz Bandwidth (MHz)');
        end;
        hold off;
        title('FWHM');
        
        %Center Frequnecy
        [~,plotIt]=subplot42(numplots,plotIt);
        hold on;
        for magidx=1:1:size(freqs,2)
            plot(xvalues,lorentzdata(:,7,magidx)./1E9',colorarr{magidx},'LineWidth',3);
            xlabel(xtitle);
            xlim(xlimits);
            ylabel('Center Freq (GHz)');
        end;
        hold off;
        title('Center Frequency');
        
        %residuum
        [~,plotIt]=subplot42(numplots,plotIt);
        hold on;
        for magidx=1:1:size(freqs,2)
            plot(xvalues,lorentzdata(:,6,magidx)',colorarr{magidx},'LineWidth',3);
            xlabel(xtitle);
            xlim(xlimits);
            ylabel('Residuum');
        end;
        hold off;
        title('Residuum');
        
        %insertion loss and noise level
        [~,plotIt]=subplot42(numplots,plotIt);
        hold on;
        for magidx=1:1:size(freqs,2)
            plot(xvalues,lorentzdata(:,9,magidx)',colorarr{magidx},'LineWidth',3);
            plot(xvalues,lorentzdata(:,10,magidx)',colorarr{magidx},'LineWidth',3);
            xlabel(xtitle);
            xlim(xlimits);
            ylabel('IL (dB) Noise (dB)');
        end;
        hold off;
        title('Insertion loss and noise level (dB)');
        
        %Q-factor
        [~,plotIt]=subplot42(numplots,plotIt);
        hold on;
        for magidx=1:1:size(freqs,2)
            plot(xvalues,lorentzdata(:,11,magidx)',colorarr{magidx},'LineWidth',3);
            xlabel(xtitle);
            xlim(xlimits);
            ylabel('Q-factor');
        end;
        hold off;
        title('Q-factor');
        
end