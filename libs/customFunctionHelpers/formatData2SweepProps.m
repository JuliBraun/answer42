function [sweepProps] = formatData2SweepProps(tdmsdata)
    for i=1:size(sweeps,2)
        sweepProps=tdmsdata.sweep_0
    end
end