function plotDT = plotDTParams(dataprops,handles)

        propsdatnames=fieldnames(dataprops);
        for ii=1:numel(propsdatnames)
             if strcmp(propsdatnames{ii},'Comment')
                 comment=dataprops.(propsdatnames{ii});
                 commentArray=strsplit(comment,'\n','CollapseDelimiters',false);
                 propsdatvalues{ii}=strjoin(commentArray,' | ');
             else
                propsdatvalues{ii}=dataprops.(propsdatnames{ii});
             end
        end;
        dat=horzcat(propsdatnames,propsdatvalues');
        columnname={'Property', 'Value'};
        
        %[actplot,plotIt]=subplot42(numplots,plotIt);
        plotDT=handles.TDMS_props;
        set(plotDT,'Data',dat, 'ColumnName', columnname,'RowName',[],'ColumnWidth',{200,500},'ColumnFormat',{'char','char'});

        plotComment=handles.TDMS_comment;
        commentTable=cellstr(commentArray');
        set(plotComment,'Data',commentTable,'ColumnWidth',{300},'RowName',[],'ColumnName','Comments');
%         ,'Units','normalized','
end