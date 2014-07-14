dataDir='/media/alexgmcm/Elements/artefactFree/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};
load('useHealthySubjects.mat'); %loads metadata in healthySubjects 220x3 cell array
%the index for healthysubjects is the same as that for filenames so should be easy to construct feature vector in one loop
%feature vector: filename age isMale deltarp thetarp alpharp beta1rp beta2rp gammarp
%use welch to get peridogram due to less noise, but what to use for size of overlapping windows?


%get periodogram via welch for each epoch in channel, average them across the epochs for each channel.

saveDir='/media/alexgmcm/Elements/relativePowersPerChan/';

for i=1:length(filenames)
(i/length(filenames))*100
load(strcat(dataDir,filenames{i}));
fs=data_no_artifacts.fsample; %sampling frequency, Hz
%delta band (1.5-4hz)
%theta (4-8Hz)
%alpha band (8-13Hz)
%Beta1 band(13-19Hz)
%Beta2 band(19-30Hz)
%gamma band (30-40Hz)
window = floor(2*fs);
noverlap=ceil(0.75*window);
 %need value that will get sufficient cycles - ask javier
%let window be 2 seconds in length
%let overlap be 75%

%need to calculate periodograms for each channel in each epoch... how to do this efficiently? write my own function and call with cellfun?


		[pxx,f] = cellfun(@(x) applyWelch(x),data_no_artifacts.trial,'UniformOutput',false);
		f=f{1}(1,:);
		averagePSDs= (sum(cat(3,pxx{:}),3))./size(pxx,2);
		cellPSDs=num2cell(averagePSDs,2);
		totalpow=cell2mat(cellfun(@(x) bandpower(x,f,[1.5 40],'psd'),cellPSDs,'UniformOutput',false));

		deltarp=cell2mat(cellfun(@(x) bandpower(x,f,[1.5 4],'psd'),cellPSDs,'UniformOutput',false))./totalpow;
		thetarp=cell2mat(cellfun(@(x) bandpower(x,f,[4 8],'psd'),cellPSDs,'UniformOutput',false))./totalpow;
		alpharp=cell2mat(cellfun(@(x) bandpower(x,f,[8 13],'psd'),cellPSDs,'UniformOutput',false))./totalpow;
		beta1rp=cell2mat(cellfun(@(x) bandpower(x,f,[13 19],'psd'),cellPSDs,'UniformOutput',false))./totalpow;
		beta2rp=cell2mat(cellfun(@(x) bandpower(x,f,[19 30],'psd'),cellPSDs,'UniformOutput',false))./totalpow;
		gammarp=cell2mat(cellfun(@(x) bandpower(x,f,[30 40],'psd'),cellPSDs,'UniformOutput',false))./totalpow;
		
		relativePowersPerChan=[deltarp thetarp alpharp beta1rp beta2rp gammarp];
		save(strcat(saveDir,filenames{i}),'relativePowersPerChan','-mat');
		varlist={'data_no_artifacts', 'window', 'noverlap', 'pxx', 'f', 'averagePSDs', 'cellPSDs', 'totalpow', 'deltarp', 'thetarp', 'alpharp', 'beta1rp', 'beta2rp', 'gammarp', 'relativePowersPerChan'};
		clear(varlist{:});


end
