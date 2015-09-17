function writeToPPTX( handles,plotname )
%WRITETOPPTX Summary of this function goes here
%   Detailed explanation goes here

sendStatus(handles,'saving figures...');
if plotname(1)=='\'
    plotname=strjoin({'\',plotname},'');
end
        %set(0,'DefaultAxesFontName','Arial','DefaultAxesFontSize',10,'DefaultTextBackgroundColor','none');
        %set(0, 'defaultfigurecolor', 'g', 'defaultaxescolor', 'None');
set(0,'DefaultTextFontName','Arial');

subhandle=allchild(handles.plotPanel);
subhandleSelection=strcmp(get(subhandle,'Type'),'axes');
subhandle=subhandle(subhandleSelection);
subSize=size(subhandle,1);
set(0,'DefaultFigureVisible','off');
for it=1:subSize  
    
    
    sendStatus(handles,char(strcat({'moving to fig '},num2str(it))));
    main_handle=subhandle(it);
    %if axes has no title it can be a colorbar or else the filename would
    %be unknown
    figTitle=get(get(main_handle,'title'),'String');
    if strcmp(figTitle,'')
        continue;
    end
    tic;
    corFigTitle=strrep(figTitle, ' ', '_');
    corFigTitle=strrep(corFigTitle, ':', '_');
    figname=strcat(plotname,corFigTitle,'.fig');
    pngname=strcat(plotname,corFigTitle);
    
    chld_lst=get(main_handle,'Children');

    
    sendStatus(handles,char(strcat({'resizing fig '},num2str(it))));
    %create new figure is important cause gui does only allow one master
    %figure
    savefig = figure('PaperUnits','centimeters','PaperSize',[7.5 5.625]);
    ax_new = copyobj(main_handle, savefig);
    set(ax_new, 'Position', get(0, 'DefaultAxesPosition'),'box','on');
    xlimits = xlim;
    ylimits = ylim;
    title(figTitle);
    grid off
    %if figure is a surface plot or image add colorbar
    for n=1:10
        try
            if strcmp(get(chld_lst(n),'Type'),'image')|| strcmp(get(chld_lst(n),'Type'),'surface')
                   % ||strcmp(get(chld_lst(4),'Type'),'image')
                g=colorbar('vert');
                set(g,'LineWidth',1);
                zlab = get(g,'ylabel');
                set(g,'units', 'normalized','position',[0.775 0.2 0.03 0.75],'LineWidth',1)
                if ~isempty(strfind(corFigTitle, 'Mag'))||~isempty(strfind(corFigTitle, 'mag'))
                    set(zlab,'String','Magnitude (dB)','FontSize',10,'FontName','Arial');
                elseif strfind(corFigTitle, 'amplitude')
                    set(zlab,'String','Power (dBm)','FontSize',10,'FontName','Arial');
                else
                    set(zlab,'String','Phase (deg)','FontSize',10,'FontName','Arial');
                end 
            end
        catch
        end
    end
        colormap(LabCmap('WMI'));
        set(gcf,'units', 'centimeters', 'position', [20 20 7.5 5.625]);
        set(gca,'box', 'on','Layer','top','TickLength',[.02 .02],'LineWidth', 1,'units', 'normalized', 'position', [0.2 0.2 0.55 0.75]); 
        xlim(xlimits);
        ylim(ylimits);
    %typically round 0.1s
    
    figname=strrep(figname,'-','m');
    figname=strrep(figname,'=','eq');
    if iscell(figname)
        figname=figname{1};
    end;
    pngname=strrep(pngname,'-','m');
    pngname=strrep(pngname,'=','eq');
    if iscell(pngname)
        pngname=pngname{1};
    end;
    
    sendStatus(handles,char(strcat({'saving as .fig  fig '},num2str(it))));
    saveas(savefig,figname,'fig');   

    set(gcf, 'Color', 'None');
    set(gca,'Color', 'None'); 
    %typically round 0.5s
    
    sendStatus(handles,char(strcat({'saving as .pdf  fig '},num2str(it))));
    export_fig(pngname,savefig,'-pdf','-transparent','-nocrop');
    %set(gca,'box', 'on', 'Color', 'None','Layer','top','TickLength',[.02 .02],'LineWidth', 1,'units', 'centimeters', 'position', [0.2 0.15 0.6 0.6]); 
    set(gcf, 'Color', 'None','units', 'centimeters', 'position', [0 0 20 15]);  
    sendStatus(handles,char(strcat({'saving as .png  fig '},num2str(it))));
    export_fig(pngname,savefig,'-png','-transparent','-nocrop');
    close(savefig);
    
    
    sendStatus(handles,char(strcat({'setting visibility of fig '},num2str(it))));
    %set visibility to normal (usually very fast)
    f=load(figname,'-mat');
    n=fieldnames(f);
    f.(n{1}).properties.Visible='on';
    %f.(n{1}).properties.VisibleMode='on';
    save(figname,'-struct','f');
end;
set(0,'DefaultFigureVisible','on');

sendStatus(handles,'fig saving done');