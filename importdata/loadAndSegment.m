function segmentedData = loadAndSegment(filename)
	%load data and segment in same way field trip would - use try statements to skip corrupted epochs



	%assume filename is just the filename - see importscript
	dataDir='~/data/ControlsMEG/';
	%test code
	%filename='AFAL38.DATA';
	Nchan=148; %no. of MEG channels
	fsample=169.55;
	%sampling rate in Hz
	 %See 'Spectral Changes in spontaneous MEG activity across the lifespan', Gómez et al. (2013)

	%need to calculate the indices for splitting using sampling rate

	segmentLength=5; % segmentlength in seconds

	%get length of signal (i.e. number of lines)
	[status, result] = system( ['wc -l ', strcat(dataDir, filename)] );
	numlinesstr = regexp(result, '(^[0-9]+)?', 'match');
	numlines = str2num( numlinesstr{1} );


	%segments will not overlap.
	%fieldTrip uses round to ensure integer index, I will do the same (as opposed to floor or ceil) to ensure compatibility
	nSampPerSeg=round(segmentLength*fsample);
	segIndices=[1:nSampPerSeg:numlines];
	sampleInfo(:,1)=segIndices(1:end-1);
	sampleInfo(:,2)=segIndices(2:end)-1;

	segmentedData.sampleinfo=sampleInfo;
	segmentedData.fsample=fsample;

	segmentedData.label=cellstr(num2str([1:Nchan]'));

	%This will be done in segments below - this code was from loadStructuredData
	%MEGData = loadMEGData(strcat(dataDir,filename));
	%segmentedData.trial={MEGData(:,2:end)'};
	%segmentedData.time={MEGData(:,1)'};


%hdr info as defined by FieldTrip
	segmentedData.hdr.nChans=Nchan;
	segmentedData.hdr.label=cellstr(num2str([1:Nchan]'));
	segmentedData.hdr.Fs=fsample;
	nSamples=numlines;
	nTrials=1; %continuous?

%didn't include segmentedData.cfg as that seems strange and probably unnecessary

	% %remember to deal with corruptions...
	% load('corruptions.mat'); %loads cell array of filename and line of corruptions, convert this to structure so we can treat it like dict

	% %strip file extension to have valid field name REMEMBER TO ALSO DO THIS WHEN REFERENCING USING FILENAME BEING LOADED
	% errors(:,1)=cellfun(@stripFileExtension,errors(:,1),'UniformOutput', false);
	% corruptions=struct;

	% for i=1:length(errors);
	% 	if ~isfield(corruptions, errors{i,1})
	% 		corruptions.(errors{i,1}).lines = [errors{i,2}];
	% 	else
	% 		corruptions.(errors{i,1}).lines = [corruptions.(errors{i,1}).lines errors{i,2}];
			
	% 	end
	% end
	% %wait... if we are using the try statement method rather than manual skipping we don't even need the corruption info ugh..

%load data in little segments stored in segmentedData.trial cellarray (1x nSegs) of segment arrays (nChans*nSampPerSeg)
%if we do it one at a time then with a try statement to skip corruptions then we don't have to deal with them in an awkward way
%hopefully multiple loadMEGData calls won't be *too* much slower than a single call or few calls only where there are corruptions
%if this proves to be too slow can do this later

nSegs = floor(numlines/nSampPerSeg);
j=1;
segmentedData.trial=cell(1,nSegs);

for i=1:nSegs
	try
	currentSeg=loadMEGData(strcat(dataDir,filename),sampleInfo(i,1),sampleInfo(i,2));
	segmentedData.trial{j}=currentSeg(:,2:end)';
	segmentedData.time{j}=currentSeg(:,1)';
	j=j+1;
	catch exception
		disp(exception.message);
	end
end
%this puts all the trials next to one another in the trial array even if they are not consecutive due to removal of corruptions
%their time vectors will show that they aren't consecutive - can easily change this to have empty entries if that turns out to be
%more convenient

end




