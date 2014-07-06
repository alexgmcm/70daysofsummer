function header = loadFieldTrip(filename)

load('4D_header.mat'); %load header
dataDir='/media/alexgmcm/Elements/completeData/';
load(strcat(dataDir,filename));%load mat file of MEGData
header.nChans=148;
header.label=cellfun(@(x)strcat('A',strtrim(x)),cellstr(num2str([1:header.nChans]')),'UniformOutput',false);
header.nSamples=size(MEGData,1);
header.chantype=cellstr(repmat('meg',148,1));
header.chanunit=cellstr(repmat('T',148,1));
%header.Fs = sampling rate?? maybe?? wut?
end