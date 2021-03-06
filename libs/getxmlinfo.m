function xmlinfo=getxmlinfo(pathname,filename,xcaselist,ycaselist)
    %% change path to xmlpath
    tmpstr=strsplit(pathname,'\');
    tmpstr2=strsplit(filename,'.');
    display(pathname);
    %change -2 in second strjoin if .dat extension is not needed anymore to
    %-1
    xmlstr=strcat(strjoin(tmpstr(1:size(tmpstr,2)-2),'\'),'\Analysis\',...
        strjoin(tmpstr2(1:size(tmpstr2,2)-2),'.'),'\','configuration.xml');
    
    %% read and evaluate xml 
    %hint: LV omits newlines, so <Name>zCase</Name>..
    %that cannot be read as a single element
    %use this to list items of node
    %     for i=0:xRoot.getLength()-1
    %         display(strcat('index  ',num2str(i),' has Name "',...
    %             char(xRoot.item(i).getNodeName()),'" and Value "',...
    %             char(xRoot.item(i).getNodeValue()),'"'));
    %     end
    tree=xmlread(xmlstr);
    %get LVData elements
    xRoot = tree.getFirstChild().getChildNodes();
    %get Cluster element
    xRoot=xRoot.item(3).getChildNodes();
    %get Array element
    xRoot=xRoot.item(5).getChildNodes();
    %get Cluster element
    xRoot=xRoot.item(5).getChildNodes();
    %xCase
    xCase=xRoot.item(7).getChildNodes();
    xCase=xCase.item(9).getChildNodes();
    xCase=xCase.item(3).getFirstChild().getNodeValue();
    %yCase
    yCase=xRoot.item(9).getChildNodes();
    yCase=yCase.item(9).getChildNodes();
    yCase=yCase.item(3).getFirstChild().getNodeValue();
    
%% set output
    xmlinfo{1}=xcaselist{str2num(char(xCase))+1};
    xmlinfo{2}=ycaselist{str2num(char(yCase))+1};

    
    