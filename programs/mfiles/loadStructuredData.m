% Load data from file in structure required by FieldTrip
% Can then call this with currentData=loadStructuredData(filenames{i}) in loop in main script
% As we cannot load 20gb of data into RAM simultaneously 



function dataStructure = loadStucturedData(filename)
	%assume filename is just the filename - see importscript
	%dataDir='~/data/ControlsMEG/completeData';
	dataDir='/media/alexgmcm/Elements/completeData/';
	Nchan=148;
	fsample=169.55; %See 'Spectral Changes in spontaneous MEG activity across the lifespan', Gómez et al. (2013)

	dataStructure.fsample=fsample;
	dataStructure.label=cellfun(@(x)strcat('A',strtrim(x)),cellstr(num2str([1:Nchan]')),'UniformOutput',false);

%	dataStructure.label=cellstr(num2str([1:Nchan]'));
	%MEGData = loadMEGData(strcat(dataDir,filename));
	load(strcat(dataDir,filename));
	dataStructure.trial={MEGData(:,2:end)'};
	dataStructure.time={MEGData(:,1)'};
	startSample = 1;
	endSample = size(MEGData,1);
	dataStructure.sampleinfo = [startSample endSample];
end

