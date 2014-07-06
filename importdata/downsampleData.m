filenames={'TCE_08.mat'; 'TCE_22.mat'};
dataDir='/media/alexgmcm/Elements/completeData/';
saveDir='/media/alexgmcm/Elements/downsampledData/';

for i=1:length(filenames)
	load(strcat(dataDir,filenames{i}))
	%the data in each .mat is saved as variable MEGData matrix
	%decimate MEG signal, downsample timevec (don't want to filter timevec)
	newMEGData=[downsample(MEGData(:,1),4)];
	for j=2:149
		newMEGData = [newMEGData decimate(MEGData(:,j),4) ];
	end
	clear MEGData;
	MEGData = newMEGData;
	save(strcat(saveDir,filenames{i}), 'MEGData', '-mat');
	clear MEGData;
end
