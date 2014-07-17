dataDir='/media/alexgmcm/Elements/mci/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};

for i=19:length(filenames)
	(i/length(filenames))*100
	MEGData = loadDiffFormat(filenames{i});
	MEGData=MEGData./1e5;
	save(strcat('/media/alexgmcm/Elements/mciCompleteData/', filenames{i},'.mat'), 'MEGData','-mat');
end