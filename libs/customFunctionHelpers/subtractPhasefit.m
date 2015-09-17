function subtractphasefitdat=subtractPhasefit(freqs,sparameters,filename,handles,myflags)

size(freqs)
size(sparameters)
subtractphasefitdat=repmat(1,[size(sparameters,1) size(sparameters,2) ceil(size(sparameters,3)/2) size(sparameters,4)]);
for ii=1:ceil(size(sparameters,3)/2)
    for jj=1:size(sparameters,4)
        %treat only 1st sweep
        %heal out phase jumps
        fitfunc=fit(freqs(:,jj),sparameters(1,:,2*ii,jj)',fittype({'1','1e-9*x'}));
        fitvec=fitfunc(freqs(:,jj));
        %to be optimized
        for kk=1:size(subtractphasefitdat,1)
            for ll=1:size(subtractphasefitdat,2)
                subtractphasefitdat(kk,ll,ii,jj)=sparameters(kk,ll,2*ii,jj);
                while 1
                    if subtractphasefitdat(kk,ll,ii,jj)-fitvec(ll)>180
                        subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)-360;
                    elseif subtractphasefitdat(kk,ll,ii,jj)-fitvec(ll)<-180
                        subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)+360;
                    end;
                    if abs(subtractphasefitdat(kk,ll,ii,jj)-fitvec(ll))<=180
                        break;
                    end;
                end;
            end;
        end;
        fitfunc=fit(freqs(:,jj),subtractphasefitdat(1,:,ii,jj)',fittype({'1','1e-9*x'}));
        fitvec=fitfunc(freqs(:,jj));
        for kk=1:size(subtractphasefitdat,1)
            for ll=1:size(subtractphasefitdat,2)
                while 1
                    if subtractphasefitdat(kk,ll,ii,jj)-fitvec(ll)>180
                        subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)-360;
                    elseif subtractphasefitdat(kk,ll,ii,jj)-fitvec(ll)<-180
                        subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)+360;
                    end;
                    if abs(subtractphasefitdat(kk,ll,ii,jj)-fitvec(ll))<=180
                        break;
                    end;
                end;
            end;
        end;
        %get avg slope > 0, this step heals most of the errors
%         avgsum=0;
%         avgiter=0;
%         for ll=1:size(subtractphasefitdat,2)-1
%             if subtractphasefitdat(1,ll,ii,jj)<subtractphasefitdat(1,ll+1,ii,jj)
%                 avgiter=avgiter+1;
%                 avgsum=avgsum+subtractphasefitdat(1,ll+1,ii,jj)-subtractphasefitdat(1,ll,ii,jj);
%             end;
%         end;
%         avgsum=avgsum/avgiter;
%         for kk=1:size(subtractphasefitdat,1)
%             for ll=1:size(subtractphasefitdat,2)
%                 while 1
%                     if subtractphasefitdat(kk,ll,ii,jj)-(ll-1)*avgsum>180
%                         subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)-360;
%                     elseif subtractphasefitdat(kk,ll,ii,jj)-(ll-1)*avgsum<-180
%                         subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)+360;
%                     end;
%                     if abs(subtractphasefitdat(kk,ll,ii,jj)-(ll-1)*avgsum)<=180
%                         break;
%                     end;
%                 end;
%             end;
%         end;
        %       subtract linear fit
%         fitfunc=fit(freqs(:,jj),subtractphasefitdat(1,:,ii,jj)',fittype({'1','1e-9*x'}));
%         fitvec=fitfunc(freqs(:,jj));
        subtractphasefitdat(:,:,ii,jj)=bsxfun(@minus,subtractphasefitdat(:,:,ii,jj),fitvec');
        %last check if everything is in range
%         for kk=1:size(subtractphasefitdat,1)
%             for ll=1:size(subtractphasefitdat,2)
%                 while 1
%                     if subtractphasefitdat(kk,ll,ii,jj)>180
%                         subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)-360;
%                     elseif subtractphasefitdat(kk,ll,ii,jj)<-180
%                         subtractphasefitdat(kk,ll,ii,jj)=subtractphasefitdat(kk,ll,ii,jj)+360;
%                     end;
%                     if abs(subtractphasefitdat(kk,ll,ii,jj))<=180
%                         break;
%                     end;
%                 end;
%             end;
%         end;
    end;
end;
if getCustomParams(myflags,'Subtract Average')
    for ii=1:ceil(size(sparameters,3)/2)
        for jj=1:size(sparameters,4)
            subtractphasefitdat(:,:,ii,jj)=bsxfun(@minus,subtractphasefitdat(:,:,ii,jj),mean(subtractphasefitdat(:,:,ii,jj)));
        end;
    end;
end;
sendStatus(handles,'saving case data...');
try
    save(filename,'subtractphasefitData','-append');
    sendStatus(handles,'saving case data...\n done');
catch
    sendStatus(handles,'save error');
end
end