dataDir='/media/alexgmcm/Elements/alzCompleteData/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};

for i=1:length(filenames)
	(i/length(filenames))*100
	load(strcat(dataDir,filenames{i}));
	MEGData=MEGData.*10;
	save(strcat('/media/alexgmcm/Elements/alzCompleteData/', filenames{i}), 'MEGData','-mat');
end