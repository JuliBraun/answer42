function savefig42(handles,axishandle,type,plotname)

subhandle=allchild(handles.plotPanel);
subhandleSelection=strcmp(get(subhandle,'Type'),'axes');
subhandle=subhandle(subhandleSelection);
set(0,'DefaultFigureVisible','off');

% main_handle=subhandle(plotIt);
main_handle=axishandle;
%if axes has no tplotItle plotIt can be a colorbar or else the filename would
%be unknown

if 0
figTitle=get(get(main_handle,'title'),'String');
corFigTitle=strrep(figTitle, ' ', '_');
% figname=strcat(plotname,corFigTitle,'.fig');
pngname=strcat(plotname,corFigTitle,type);
else
    if strcmpi(type,'.fig')
     pngname=strcat(plotname,'.fig');
    else
    pngname=strcat(plotname,type);
    end
end
chld_lst=get(main_handle,'Children');

%create new figure is important cause gui does only allow one master
%figure
savefig = figure;
ax_new = copyobj(main_handle, savefig);
set(ax_new, 'Position', get(0, 'DefaultAxesPosition'));

%if figure is a surface plot or image add colorbar
if strcmp(get(chld_lst(1),'Type'),'surface')...
        ||strcmp(get(chld_lst(1),'Type'),'image')
    colorbar;
    colormap(LabCmap('bluegreenyellow'));
end

%typically round 0.1s
if strcmpi(type,'.fig')
   saveas(savefig,pngname,'fig');
%typically round 0.5s
else
export_fig(pngname,savefig);
end
close(savefig);
if strcmpi(type,'.fig')
% set visibilplotIty to normal (usually very fast)
f=load(pngname,'-mat');
n=fieldnames(f);
f.(n{1}).properties.Visible='on';
save(pngname,'-struct','f');
end

set(0,'DefaultFigureVisible','on');
end