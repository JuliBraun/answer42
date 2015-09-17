function h=plotsurf_FPGA_Driven_Rabi(x, y, z,tit,xtitle,range)
                 
xrange = range(1,1:2);
yrange = range(1,3:4);
zrange = range(1,5:6);

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
            if strfind(tit, 'Magnitude')
                set(zlab,'String','Magnitude (dBm)','FontSize',10,'FontName','Arial');
                setRange(zrange,1,'z');
            else
                set(zlab,'String','Phase (rad)','FontSize',10,'FontName','Arial');
            end
        %set(zlab,'String','Amplitude (arb. units)','FontSize',10,'FontName','Arial'); 
        xlabel(xtitle);
        ylabel('Time (µs)');
        title(strrep(tit,'_',' '));

     setRange(xrange,1,'x');
     setRange(yrange,1,'y');

end