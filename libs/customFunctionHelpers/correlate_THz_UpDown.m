function currDownCorrelated = correlate_THz_UpDown( freqUp,currUp,freqDown,currDown,varargin)
%CORRELATE_THZ_UPDOWN Get the Frequencyshift between up and down sweep 
%by Crosscorrelation.
%   Detailed explanation goes here
currDown2=interp1(freqDown,currDown,freqUp);
currDown2(isnan(currDown2))=0;
if isempty(varargin)
    [acor,lag]=xcorr(currUp,currDown2);
    [~,shift] = max(acor);
    shift=lag(shift)*mean(freqUp(2:end)-freqUp(1:end-1));
    currDownCorrelated=interp1(freqUp+shift,currDown2,freqUp);
else
    part=varargin{1};
    parts=(max(freqUp)-min(freqUp))/part;
    currDownCorrelated=zeros(size(currUp));
    for ind=1:ceil(parts)
        tmp=find(freqUp>(min(freqUp)+(ind-1)*part)&freqUp<(min(freqUp)+ind*part));
        [acor,lag]=xcorr(currUp(tmp),currDown2(tmp));
        [~,shift] = max(acor);
        shift=lag(shift)*mean(freqUp(tmp(2:end))-freqUp(tmp(1:end-1)));
        currDownCorrelated(tmp)=interp1(freqUp+shift,currDown2,freqUp(tmp));
    end
end
end

