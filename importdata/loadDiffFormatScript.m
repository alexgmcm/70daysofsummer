dataDir='~/data/ControlsMEG/different_format/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};

for i=1:length(filenames)
	MEGData = loadDiffFormat(filenames{i});
	save(strcat('/media/alexgmcm/Elements/completeData/', filenames{i},'.mat'), 'MEGData','-mat');
end