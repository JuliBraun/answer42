function [freqs,sparameters,titles]=formatMat2ZVA(matdata,yheaders,dataprops)
        %This function formats matdata to zvaspecific data with mag phase
        %freqs etc
        if  strcmp(dataprops.YCaseName,'DualZVA24 Frequency Sweep')
            nrFreqs=size(strsplit(dataprops.YCaseStrPar4p_Center_Freq__GHz_,':'),2)+...
                size(strsplit(dataprops.YCaseStrPar2p_Center_Freq__GHz_,':'),2);
            nrSpar=size(strsplit(dataprops.YCaseStrPar2p_S_Parameters,':'),2)+...
                size(strsplit(dataprops.YCaseStrPar4p_S_Parameters,':'),2);
        else
            try %backward compatibility
                %how many stimulus are there?
                nrFreqs=size(strsplit(dataprops.YCaseStrParCenter_Freq__GHz_,':'),2);
                %how many Sparas are there?
                nrSpar=2*size(strsplit(dataprops.YCaseStrParS_Parameters,':'),2);
            catch %backward compatibility
                display('unknown case');
                nrSpar=2;
                if isfield(dataprops,'YCaseNumParCenter_frequency_2__GHz_')
                if isnan(dataprops.YCaseNumParCenter_frequency_2__GHz_)
                    nrFreqs=1;
                elseif isnan(dataprops.YCaseNumParCenter_frequency_3__GHz_)
                    nrFreqs=2;
                else
                    nrFreqs=3;
                end;
                else
                nrFreqs=1;
                end
            end;
        end;
        if strcmp(dataprops.YCaseName,'FSVSpectrumAnalyzer')
            nrSpar=1;
        end
        sparameters=ones(size(matdata,1),size(matdata,2),nrSpar,nrFreqs);
        %dirty workaround
        if nrFreqs==1
            freqs(:,1)=matdata(1,:,1);
        else
            freqs(:,:)=matdata(1,:,1:nrSpar+1:nrFreqs*(nrSpar+1)-nrSpar);
        end;
        %     freqs=freqs(1,:,:);
        for ii=1:nrFreqs
            for jj=1:nrSpar
                if length(yheaders)>2
                sparameters(:,:,jj,ii)=matdata(:,:,(ii-1)*(nrSpar+1)+jj+1);
                titles{jj,ii}=yheaders{(ii-1)*(nrSpar+1)+jj+1};
                else
                sparameters(:,:,jj,ii)=matdata(:,:,(ii-1)*(nrSpar+1)+jj+1);
                titles{jj,ii}=yheaders{(ii-1)*(nrSpar+1)+jj+1};
                end
            end;
        end;
end