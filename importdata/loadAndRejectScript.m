%Load each bit of data in turn (dealing with corruptions) and perform artefact rejection then save the resulting
%cleaned signals

%to begin with we must write outer loop over filenames that will load the data
dataDir='/home/alexgmcm/data/ControlsMEG/'; %set data directory
load('corruptions.mat'); %load the corruption info in errors cell array

dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};

%for each filename, check if it is in the corruptions - they need special treatment...
percentageArtefacts=zeros(length(filenames),1);
for i=1:length(filenames)
	if ~ismember(filenames{i},errors(:,1)) %returns 0 if file contains corruptions, 1 otherwise (not the negation ~)
		%normal handling code
		MEGData = loadMEGData(strcat(dataDir,filenames{i}),1,inf); %load the whole file


	else 
		%code for corrupted data: have to skip over corrupted lines and sew together... 
		errorLines= cell2mat(errors(cell2mat(cellfun(@(x)strcmp(x,filenames{i}),errors(:,1),'UniformOutput',false)),2));

		%for each entry in error lines we need to go up from1:errorline-1 then errorline+1:nextentry in errorlines-1 etc. 
		%if no more entry in error lines then go to end
		clear MEGData;
		MEGData = [];
		%get number of lines in file
		[status, result] = system( ['wc -l ', strcat(dataDir, filenames{i})] );
		numlinesstr = regexp(result, '(^[0-9]+)?', 'match');
		numlines = str2num( numlinesstr{1,1} );

		errorLines=[0; errorLines; numlines+1]; %pad error lines for loop


		for j=1:(length(errorLines)-1)
			try
			MEGData = [MEGData; loadMEGData(strcat(dataDir,filenames{i}),errorLines(j)+1,errorLines(j+1)-1)];
			catch exception
				disp(exception.message);
			end
		end

	
	end

%artefact detection code
	thresholdScale = 2.5;
	%2.5 gets mean(percentageArtefacts)=9.26, max(percentageArtefacts)=78.76, median(percentageArtefacts)=6.17
	%so it seems a good choice as it isn't rejecting too much of any data but is removing the worst artefacts
	%run run_rechazo with 2.5?

	[cleanEpochs, segmentedSignal,segmentedTime,~,~,percentageArtefacts(i)] =  rejectArtefacts(MEGData,thresholdScale);
	%pause



%rejection code


	%reconstructedEpoch=reshape(segmentedSignal{1}(repmat(cleanEpochs{1},size(segmentedSignal{1},1),1)),size(segmentedSignal{1},1),sum(cleanEpochs{1})); %need to reshape
	temp=[1:148];
	channelsinEpoch=cellfun(@(x)temp(x),cleanEpochs,'UniformOutput',false);

	reconstructedEpochs=cellfun(@(x,y)reshape(x(repmat(y,size(x,1),1)),size(x,1),sum(y)),segmentedSignal,cleanEpochs,'UniformOutput',false);
	%vectorise this to apply it to all epochs then save the result as it will be reduced in size,
	%then we get the fun of filters...

	%save file code (use StripFileExtension on filename and strcat to get new extension)
	
	save(strcat('/media/alexgmcm/Elements/artefactFree/',stripFileExtension(filenames{i}),'.mat'),'channelsinEpoch','reconstructedEpochs','segmentedTime', '-mat');


end
