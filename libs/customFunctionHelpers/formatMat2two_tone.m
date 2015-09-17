function [freqs,sparameters,titles]=formatMat2two_tone(matdata,yheaders,dataprops)
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
                nrFreqs=size(strsplit(dataprops.YCaseStrParZVA_Find_Res_Center__GHz_,':'),2);
                %how many Sparas are there?
                nrSpar=2*size(strsplit(dataprops.YCaseStrParS_Parameters,':'),2);
            catch %backward compatibility
                display('unknown case');
                nrSpar=2;
                nrFreqs=1;
                
            end;
        end;
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
                sparameters(:,:,jj,ii)=matdata(:,:,(ii-1)*(nrSpar+1)+jj+1);
                titles{jj,ii}=yheaders{(ii-1)*(nrSpar+1)+jj+1};
            end;
        end;
end