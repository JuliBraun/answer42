function [xtitle,rptitle] = checkCaseNames(dataprops)
        switch dataprops.XCaseName
            case {'SMF100A Power (dBm)'}
                xtitle='SMF Power(dBm)';
            case {'SMF100A Frequency (GHz)'}
                xtitle='Frequency (GHz)';
            case {'PSG Frequency (GHz)'}
                xtitle='Frequency (GHz)';
            case {'SGS Power (dBm)'}
                xtitle='SGS Power(dBm)';
            case {'Keithley6430 Current (uA)','Keithley2450 Current (uA)','Keithley2450 Current (uA) Edwin', 'Keithley6430 Current (uA) with pers switch','Add DC Bias K12','Flux Bias K12','Keithley24XX Current (uA)','GSQ Current (uA) DAQ Channel 0','GSQ Current (uA) DAQ Channel 1','GSQ Current (uA) DAQ Channel 2','GSQ Current (uA) DAQ Channel 3'}
                xtitle='Coil Current (uA)';
            case {'ZVA24 Power','ZVA_B Power','ZVA-B Power'}
                xtitle='ZVA Power (dBm)';
            case {'counter'}
                xtitle='Time (minute)';
            case {'Keithley6430 Current (uA)'}
                xtitle='Coil Current (uA)';
                case {'Keithley2450 Current (uA)'}
                xtitle='Coil Current (uA)';
            case {'Keithley24XX Current (uA)'}
                xtitle='Coil Current (uA)';
            case {'Set Global Parameter'}
                switch dataprops.XCaseStrParParameter_Name
                    case {'ZVA Power','Power (dBm)','ZVA Power (dBm)'}
                        xtitle='ZVA Power (dBm)';
                    case {'Drive Freq (GHz)'}
                        xtitle='Drive Frequency (GHz)';
                    otherwise
                        xtitle='unknown parameter';
                end
            otherwise
                xtitle='unknown parameter';
        end
        if isfield(dataprops, 'RunPar0Name')
            switch dataprops.RunPar0Name
                case {'SMF100A Power (dBm)'}
                    rptitle='SMF Power(dBm)';
                case {'Keithley6430 Current (uA)', 'Keithley6430 Current (uA) with pers switch','Add DC Bias K12','Flux Bias K12','Keithley24XX Current (uA)','GSQ Current (uA) DAQ Channel 0','GSQ Current (uA) DAQ Channel 1','GSQ Current (uA) DAQ Channel 2','GSQ Current (uA) DAQ Channel 3'}
                    rptitle='Coil Current (uA)';
                case {'Set Global Parameter'}
                    switch dataprops.RunPar0StrParParameter_Name
                        case {'ZVA24 Power','ZVA_B Power','ZVA-B Power'}
                                rptitle='ZVA Power (dBm)';
                        otherwise
                        rptitle='unknown parameter';
                    end
                otherwise
                    rptitle='unknown parameter';
            end
        else
             rptitle='unknown parameter';
        end
    end
