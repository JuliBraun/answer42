function [ plotname,evalname ] = createFileNames( fullfilename )
%CREATEFILENAMES Summary of this function goes here
%   Detailed explanation goes here

% splitname=strsplit(fullfilename,filesep);
% filename=splitname{size(splitname,2)};
% filename=strsplit(filename,'.');
% filename=filename{1};
[path,name,ext]=fileparts(fullfilename);
parentFolder=fileparts(path);

% splitname=splitname(1:size(splitname,2)-1);
% splitname{size(splitname,2)}='Analysis\';
% evalname=strjoin(splitname,'\');
% evalname=char(strcat(evalname,filename,'\'));
evalname=fullfile(parentFolder,'Analysis',name,filesep);

% splitname{size(splitname,2)}='Plots';
% plotname=strjoin(splitname,'\');
% plotname=char(strcat(plotname,'\',filename,'\'));
plotname=fullfile(parentFolder,'Plots',name,filesep);

if evalname(1)=='\'
    evalname=strcat('\',evalname);
end
if ~exist(plotname,'dir')
    [~,~,~]=mkdir(plotname);
end;
if ~exist(evalname,'dir')
    [~,~,~]=mkdir(evalname);
end

    
end

