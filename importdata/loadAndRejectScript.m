%Load each bit of data in turn (dealing with corruptions) and perform artefact rejection then save the resulting
%cleaned signals

%to begin with we must write outer loop over filenames that will load the data
dataDir='/home/alexgmcm/data/ControlsMEG/'; %set data directory
load('corruptions.mat'); %load the corruption info in errors cell array

dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};

%for each filename, check if it is in the corruptions - they need special treatment...

for i=1:length(filenames)
	if ~ismember(filenames{i},errors(:,1)) %returns 0 if file contains corruptions, 1 otherwise (not the negation ~)
		%normal handling code
		MEGData = loadMEGData(strcat(dataDir,filenames{i}),1,inf); %load the whole file


	else 
		%code for corrupted data: have to skip over corrupted lines and sew together... 



