function h=plotsurf_zvaFrequencySweep(x, y, z,tit,xtitle)
        set(0,'DefaultAxesFontName','Arial','DefaultAxesFontSize',10,'DefaultTextBackgroundColor','none');
        set(0, 'defaultaxescolor', 'None');
        h=imagesc(x, y, z);
        set(gca,'YDir','normal')
        view(2);
        shading flat;
        colormap(LabCmap('WMI'));
        %set(gcf, 'Color', 'None');
        grid off
        set(gca,'box', 'on', 'Color', 'None','Layer','top','TickLength',[.02 .02],'LineWidth', 1.5);        
        g=colorbar('vert');
        set(g,'LineWidth',1.5);
        zlab = get(g,'ylabel');
            if strfind(tit, 'mag')
                set(zlab,'String','Amplitude (dB)','FontSize',10,'FontName','Arial');
            else
                set(zlab,'String','Phase (deg)','FontSize',10,'FontName','Arial');
            end
        %set(zlab,'String','Amplitude (arb. units)','FontSize',10,'FontName','Arial'); 
        xlabel(xtitle);
        ylabel('Frequency (GHz)');
        title(strrep(tit,'_',' '));
end