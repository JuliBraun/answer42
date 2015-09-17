function [figurehandle,newpos] = subplot42(numplots,iterator)
    figurehandle=subaxis(ceil(sqrt(numplots)),ceil(sqrt(numplots)),floor(iterator),'Spacing', 0.075, 'Padding', 0.02, 'Margin', 0.05);
    newpos=iterator+1;
end