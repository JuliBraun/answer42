function Lorentzfit_results=fitLorentzpeak(freqs,sparameters,filename,handles,titles,xtitle,xvalues,maxResiduum)                      %lorentz fits each freq sweep in magnitudes
        nrFreqs=size(freqs,2);                                              %How many Frequency spans were measured
       
        
        Lorentzfit_results=ones(numel(xvalues),11,nrFreqs);                        %Initialize variable for fit results
            for magidx=1:nrFreqs
               
                %fitfig = figure;                                              %Initialzie figure for fitting each sweep
                [fitfig,~]=subplot42(2,1);                        %Opens a subfigure for the plots
                
                lorentzname=char(strcat(strrep(filename,'casestorage.mat',''),titles(1,magidx),'_Lorentzfit_results.dat')); % Creates ascii file path
                fid = fopen(lorentzname, 'wt');                              %Opens identifier
                    Lorentzfit_results_header(1,:)={char(xtitle(1:strfind(char(xtitle),'(')-2)), 'Center freq', 'FWHM', 'Insertion loss', 'Noise level', 'Variance', 'Center freq', 'FWHM', 'Insertion loss', 'Noise level','Quality factor'};
                    Lorentzfit_results_header(2,:)={char(xtitle(strfind(char(xtitle),'(')+1:end-1)), 'Hz', 'Hz', 'dB', 'dB', '-', 'Hz', 'Hz', '-','-','-'};
                    Lorentzfit_results_header(3,:)={'','','','','','','','','','','',}; 
                    [nrows,ncols] = size(Lorentzfit_results_header);
                    for row = 1:nrows
                        for col = 1:ncols
                        Lorentzfit_results_header{row,col} = strrep(char(Lorentzfit_results_header{row,col}), ' ', '_');  %replace spaces by underscore
                        fprintf(fid, '%s\t',Lorentzfit_results_header{row,col});   %write entries of header file
                        end
                        fprintf(fid, '%s\n','');
                    end
                    Lorentzfit_results(:,1,magidx)=xvalues.';                      %Define first column as x-values
                for ii=1:numel(xvalues)              
                    fitvec=((10.^(sparameters(ii,:,1,magidx)./10)))';       %Calculate intensity from dB values
                    [mintrans,mintransi]=min(fitvec);                       %Find minimum intensity and corresponding index
                    [maxtrans,maxtransi]=max(fitvec);                       %Find maximum intensity and corresponding index
                    fitvec=(100./maxtrans).*fitvec;                         %Normalize transmission to 100%
                    startparams(4)=min(fitvec);                             %Define start value for offset
                    startparams(3)=((max(freqs(:,magidx))-min(freqs(:,magidx))))./30;     %Define start value for FWHM
                    startparams(2)=freqs(maxtransi,magidx);                        %Define start value for center freq
                    startparams(1)=max(fitvec(:)).*startparams(3);          %Define start value for insertion loss

                    if ii==1
                        evalcstr=strcat('lorentzfit(freqs(:,magidx),fitvec,[',...  
                        num2str(startparams),'],[])');
                        [~,lor,params,residuum,resC,lor_freqs]=evalc(evalcstr);
                        %create curve for initial plot:
                        startLorentz = startparams(4)+startparams(1).*startparams(3)./(((freqs(:,magidx)-startparams(2)).^2)+startparams(3).^2);

                    else
                        if isnan(Lorentzfit_results(ii-1,7,magidx))
                        evalcstr=strcat('lorentzfit(freqs(:,magidx),fitvec,[',...  
                        num2str(startparams),'],[])');
                        [~,lor,params,residuum,resC,lor_freqs]=evalc(evalcstr);
                        else
                            evalcstr=strcat('lorentzfit_dip(freqs(:,magidx),fitvec,[',...  
                            num2str(params),'],[])');
                            [~,lor,params,residuum,resC,lor_freqs]=evalc(evalcstr);
                        end;
                    end;
                    Lorentzfit_results(ii,6,magidx)=var(resC,1);

                    %sort out values with too large residuum
                    %if Lorentzfit_results(ii,6,magidx)>getCustomParams(myflags,'Lorentz max. Residuum')
                    if  Lorentzfit_results(ii,6,magidx)>maxResiduum
                        Lorentzfit_results(ii,7,magidx)=nan;       %Center freq for plot
                        Lorentzfit_results(ii,8,magidx)=nan;       %FWHM for plot
                        Lorentzfit_results(ii,9,magidx)=nan;       %Area for plot
                        Lorentzfit_results(ii,10,magidx)=nan;       %Offset for plot
                        Lorentzfit_results(ii,11,magidx)=nan;      %Q-factor
                    else
                        Lorentzfit_results(ii,7,magidx)=params(2); %Center freq for plot
                        Lorentzfit_results(ii,8,magidx)=params(3); %FWHM for plot
                        Lorentzfit_results(ii,9,magidx)=10.*log10(params(1).*maxtrans./100./params(3)); %Insertion loss for plot
                        Lorentzfit_results(ii,10,magidx)=10.*log10(params(4).*maxtrans./100); %Noise level for plot
                        Lorentzfit_results(ii,11,magidx)=params(2)./params(3);      %Q-factor
                    end;
                    Lorentzfit_results(ii,2,magidx)=params(2);     %Center freq for save file
                    Lorentzfit_results(ii,3,magidx)=params(3);     %FWHM for save file
                    Lorentzfit_results(ii,4,magidx)=10.*log10(params(1).*maxtrans./100./params(3));     %insertion loss
                    Lorentzfit_results(ii,5,magidx)=10.*log10(params(4).*maxtrans./100);     %Noise level
                    
                    plot(lor_freqs,fitvec,freqs(:,magidx),startLorentz,freqs(:,magidx),lor,'LineWidth',2);  
                    set(gca,'Color', 'None','DefaultTextBackgroundColor','None'); 
                    xlabel('frequency');
                    ylabel('intensity (arb. units)'); 
                    legend('data', 'initial values','fit');
                    sendStatus(handles,strcat('fitting Lorentzian: ',num2str(ii/numel(xvalues)*100),'%'));
                end;
                lorentz2file=Lorentzfit_results(:,:,magidx);
                save(lorentzname,'lorentz2file','-ascii','-append')          %Writes .dat file with headers
                fclose(fid);   
            end;
            delete(fitfig);
    
    sendStatus(handles,'saving case data...');            
    try
        save(filename,'Lorentzfit_results','Lorentzfit_results_header','-append');
        sendStatus(handles,'saving case data...\n done');
    catch
        sendStatus(handles,'save error');
    end
end