function fit_Lorentzpeak_values=fitLorentzdip(freqs,sparameters,filename,handles,titles,xtitle,xvalues,maxResiduum)                      %lorentz fits each freq sweep in magnitudes
        nrFreqs=size(freqs,2);                                              %How many Frequency spans were measured

% freqs_check=freqs;
% sparas_check=sparameters;
% counter=0;
% for j=1:size(freqs_check,2)         %delete all NaN's
%     for k=1:numel(xvalues)
%         counter=0;
%         for l=1:size(freqs_check,1)
%            if isnan(freqs_check(l,j))
%                freqs(l-counter,:)=[];
%                sparameters(:,l-counter,:)=[];
%                counter=counter+1;
%            end
%            if isnan(sparas_check(k,l,1))
%                freqs(l-counter,:)=[];
%                sparameters(:,l-counter,:)=[];
%                counter=counter+1;
%            else
%                if isnan(sparas_check(k,l,1))
%                    freqs(l-counter,:)=[];
%                    sparameters(:,l-counter,:)=[];
%                    counter=counter+1;
%                end
%            end
%         end
%     end
% end

        
        fit_Lorentzpeak_values=ones(numel(xvalues),11,nrFreqs);                        %Initialize variable for fit results
            for magidx=1:nrFreqs
               
                %fitfig = figure;                                              %Initialzie figure for fitting each sweep
                [fitfig,~]=subplot42(2,1);                        %Opens a subfigure for the plots
                
                lorentzname=char(strcat(strrep(filename,'casestorage.mat',''),titles(1,magidx),'_fit_Lorentzdip_values.dat')); % Creates ascii file path
                fid = fopen(lorentzname, 'wt');                              %Opens identifier
                    fit_Lorentzpeak_values_header(1,:)={char(xtitle(1:strfind(char(xtitle),'(')-2)), 'Center freq', 'FWHM', 'Dip Transmission', 'Transmission', 'Variance', 'Center freq', 'FWHM', 'Dip Transmission', 'Transmission','Quality factor'};
                    fit_Lorentzpeak_values_header(2,:)={char(xtitle(strfind(char(xtitle),'(')+1:end-1)), 'Hz', 'Hz', 'dB', 'dB', '-', 'Hz', 'Hz', '-','-','-'};
                    fit_Lorentzpeak_values_header(3,:)={'','','','','','','','','','','',}; 
                    [nrows,ncols] = size(fit_Lorentzpeak_values_header);
                    for row = 1:nrows
                        for col = 1:ncols
                        fit_Lorentzdip_values_header{row,col} = strrep(char(fit_Lorentzpeak_values_header{row,col}), ' ', '_');  %replace spaces by underscore
                        fprintf(fid, '%s\t',fit_Lorentzpeak_values_header{row,col});   %write entries of header file
                        end
                        fprintf(fid, '%s\n','');
                    end
                    fit_Lorentzpeak_values(:,1,magidx)=xvalues.';                      %Define first column as x-values
                for ii=1:numel(xvalues)  

                fitvec=((10.^(sparameters(ii,:,1,magidx)./10)))';       %Calculate intensity from dB values              
                [maxtrans,maxtransi]=max(fitvec);                       %Find maximum intensity and corresponding index
                [mintrans,mintransi]=min(fitvec);                       %Find minimum intensity and corresponding index
                fitvec=(100./maxtrans).*fitvec;                         %Normalize transmission to 100%
                startparams(4)=max(fitvec);                             %Define start value for offset
                startparams(3)=((max(freqs(:))-min(freqs(:))))./40;     %Define start value for FWHM
                startparams(2)=freqs(mintransi);                        %Define start value for center freq
                startparams(1)=max(fitvec(:)).*startparams(3);          %Define start value for insertion loss

                    if ii==1
                        %create curve for initial plot:
                        startLorentz = startparams(4)-startparams(1).*startparams(3)./(((freqs(:,magidx)-startparams(2)).^2)+startparams(3).^2);
                       
                        evalcstr=strcat('lorentzfit_dip(freqs(:,magidx),fitvec,[',...  
                        num2str(startparams),'],[])');
                        [~,lor,params,residuum,resC,lor_freqs]=evalc(evalcstr);
                    else
                        if fit_Lorentzpeak_values(ii,6,magidx)>maxResiduum
                        evalcstr=strcat('lorentzfit_dip(freqs(:,magidx),fitvec,[',...  
                        num2str(startparams),'],[])');
                        [~,lor,params,residuum,resC,lor_freqs]=evalc(evalcstr);
                        else
                            evalcstr=strcat('lorentzfit_dip(freqs(:,magidx),fitvec,[',...  
                            num2str(params),'],[])');
                            [~,lor,params,residuum,resC,lor_freqs]=evalc(evalcstr);
                        end;
                    end;

                    fit_Lorentzpeak_values(ii,6,magidx)=var(resC,1);

                    %sort out values with too large residuum
                    %if fit_Lorentzpeak_values(ii,6,magidx)>getCustomParams(myflags,'Lorentz max. Residuum')
                    if  fit_Lorentzpeak_values(ii,6,magidx)>maxResiduum
                        fit_Lorentzpeak_values(ii,7,magidx)=nan;       %Center freq for plot
                        fit_Lorentzpeak_values(ii,8,magidx)=nan;       %FWHM for plot
                        fit_Lorentzpeak_values(ii,9,magidx)=nan;       %Area for plot
                        fit_Lorentzpeak_values(ii,10,magidx)=nan;       %Offset for plot
                        fit_Lorentzpeak_values(ii,11,magidx)=nan;      %Q-factor
                    else
                        fit_Lorentzpeak_values(ii,7,magidx)=params(2); %Center freq for plot
                        fit_Lorentzpeak_values(ii,8,magidx)=params(3); %FWHM for plot
                        fit_Lorentzpeak_values(ii,9,magidx)=10.*log10(params(1).*maxtrans./100./params(3)); %Insertion loss for plot
                        fit_Lorentzpeak_values(ii,10,magidx)=10.*log10(params(4).*maxtrans./100); %Max Transmission
                        fit_Lorentzpeak_values(ii,11,magidx)=params(2)./params(3);      %Q-factor
                    end;
                    fit_Lorentzpeak_values(ii,2,magidx)=params(2);     %Center freq for save file
                    fit_Lorentzpeak_values(ii,3,magidx)=params(3);     %FWHM for save file
                    fit_Lorentzpeak_values(ii,4,magidx)=10.*log10(params(1).*maxtrans./100./params(3));     %insertion loss
                    fit_Lorentzpeak_values(ii,5,magidx)=10.*log10(params(4).*maxtrans./100);     %Max Transmission

                    plot(freqs(:,magidx),fitvec,freqs(:,magidx),startLorentz,lor_freqs,lor,'LineWidth',2);
                    set(gca,'Color', 'None','DefaultTextBackgroundColor','None'); 
                    xlabel('frequency');
                    ylabel('intensity (arb. units)'); 
                    legend('data', 'initial values','fit');
                    sendStatus(handles,strcat('fitting Lorentzian: ',num2str(ii/numel(xvalues)*100),'%'));
                end;
                lorentz2file=fit_Lorentzpeak_values(:,:,magidx);
                save(lorentzname,'lorentz2file','-ascii','-append')          %Writes .dat file with headers
                fclose(fid);   
            end;
            delete(fitfig);
    
    sendStatus(handles,'saving case data...');            
    try
        save(filename,'fit_Lorentzpeak_values','fit_Lorentzdip_values_header','-append');
        sendStatus(handles,'saving case data...\n done');
    catch
        sendStatus(handles,'save error');
    end
end