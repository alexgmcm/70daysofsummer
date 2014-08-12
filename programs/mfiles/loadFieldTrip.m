function [header, dataStructure] = loadFieldTrip(filename)

load('4D_header.mat'); %load header
dataDir='/media/alexgmcm/Elements/mciCompleteData/';
load(strcat(dataDir,filename));%load mat file of MEGData
header.nChans=148;
header.label=cellfun(@(x)strcat('A',strtrim(x)),cellstr(num2str([1:header.nChans]')),'UniformOutput',false);
header.nSamples=size(MEGData,1);
header.chantype=cellstr(repmat('meg',148,1));
header.chanunit=cellstr(repmat('T',148,1));
fsample=169.55;
header.Fs = fsample;
dataStructure.trial={MEGData(:,2:end)'};
dataStructure.time={MEGData(:,1)'};
startSample = 1;
endSample = size(MEGData,1);
dataStructure.sampleinfo = [startSample endSample];
dataStructure.fsample=fsample;
dataStructure.label=header.label;
end