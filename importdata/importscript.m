dataDir='~/data/ControlsMEG/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FieldTrip data formatting:
%data.label   % cell-array containing strings, Nchan X 1

%data.fsample % sampling frequency in Hz, single number

%data.trial   % cell-array containing a data matrix for each trial (1 X Ntrial), each data matrix is Nchan X Nsamples 

%data.time    % cell-array containing a time axis for each trial (1 X Ntrial), each time axis is a 1 X Nsamples vector 

%data.trialinfo % this field is optional, but can be used to store trial-specific information
% such as condition numbers, reaction times, correct responses etc. The dimensionality is N x M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nchan=148;
fsample=169.549; %See 'Spectral Changes in spontaneous MEG activity across the lifespan', Gómez et al. (2013)

%OLD CODE NOW LARGELY HANDLED BY loadStructuredData.m

	% %data(length(filenames))= struct('label',[], 'fsample',[], 'trial',[], 'time',[], 'trialinfo',[]); OLD UNNESTED CODE
	% label=cellstr(num2str([1:Nchan]'));
	% strippedfilenames=cellfun(@stripFileExtension,filenames,'UniformOutput', false);


	% for i=1:length(filenames)
	% 	data.(strippedfilenames{i}).label=label;
	% 	MEGData = loadMEGData(strcat(dataDir,filenames{i}));
	% 	data.(strippedfilenames{i}).fsample=fsample;
	% 	data.(strippedfilenames{i}).trial={MEGData(:,2:end)'};
	% 	data.(strippedfilenames{i}).time={MEGData(:,1)'};
	% end

%just use for loops to assign the fields - doesn't seem to vectorise easily?

%we could use trialinfo to store cognitive scores, age, gender etc.
%it is one continuous block so just 1 trial


%data folder is 22gb therefore cannot load all into RAM must deal one at a time
