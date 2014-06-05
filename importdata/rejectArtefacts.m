function [cleanEpochs, segmentedSignal] =  rejectArtefacts(signal,thresholdScale)
 
 %return indices of clean epochs in signal and segmented signal
 % based on rechazo_artefactos2.m written by Jesús Poza Crespo and modified by Javier Escudero Rodríguez
 % should to deal with variable length signals

% The code breaks the signal up into lots of mini-segments and then calcualtes the maximum displacement (from the median) of each mini-segment
% the median of these values for each channel is then used as a measure of normality for each channel. Any epoch which contains a displacement
% greater than the threshold value multiplied by this displacement is rejected as containing an artefact. 

%Deal with all channels simultaneously...

%Let signal be of shape (nSamples*nChans)
%Remember to remove time vector from data when passing signal
nSamples=size(signal,1);
nChans = size(signal,2);
%preallocate array
epochTime = 5; %epoch length in seconds
samplingRate = 169.55; %sampling rate in Hz
epochLength = round(epochTime * samplingRate); %number of samples per epoch
miniSegLength=100; %number of samples per minisegment
nMiniSegs=floor(nSamples/miniSegLength); %number of minisegments
nEpochs=floor(nSamples/epochLength);%number of epochs

cleanEpochs=zeros(nEpochs,nChans);
%thresholdScale = 3.5; Usually 3-4


%subtract the median from the signal so we can measure the deviation from the median
medianSubtractedSignal = signal- repmat(median(signal,1),nSamples,1);

miniSegCellArray=mat2cell(medianSubtractedSignal,[ones(1,nMiniSegs)*miniSegLength mod(nSamples,miniSegLength)],[148]);

maxvals = cellfun(@(x)abs(max(x,[],1)), miniSegCellArray, 'UniformOutput', false);
 %get absolute value of maximum value of each channel at each minisegment
 %UniformOutput is false because the final piece is smaller than the other minisegments
minvals = cellfun(@(x)abs(min(x,[],1)), miniSegCellArray, 'UniformOutput', false);
%same as above but for minimum values

%USE CELL2MAT HERE INSTEAD
% %need to compare each element of minvals and max vals and select the largest
% maxGreaterThanMinIndices= cellfun(@gt,maxvals,minvals,'UniformOutput',false); 
% %UniformOutput is false because the final piece is smaller than the other minisegments
% minGreaterThanMaxIndices=cellfun(@not,maxGreaterThanMinIndices,'UniformOutput',false); 
% maxGreaterValues=cellfun(@times,maxvals,maxGreaterThanMinIndices,'UniformOutput',false);
% minGreaterValues=cellfun(@times,minvals,minGreaterThanMaxIndices,'UniformOutput',false);

%need to compare each element of minvals and max vals and select the largest
maxarray=cell2mat(maxvals);
minarray=cell2mat(minvals);
maxGreaterThanMinIndices=maxarray>minarray;
devVals=(maxarray.*maxGreaterThanMinIndices) + (minarray.*(~maxGreaterThanMinIndices));
%take the median - these values will be used to create the threshold for each channel
medianDeviation=median(devVals,1);
thresholdValues=medianDeviation.*thresholdScale;

epochCellArray=mat2cell(medianSubtractedSignal,[ones(1,nEpochs)*epochLength mod(nSamples,epochLength)],[148]);
%remove final piece as it is not 5 seconds long
epochCellArray(end)=[];
maxepochvals = cellfun(@(x)abs(max(x,[],1)), epochCellArray, 'UniformOutput', false);
 %get absolute value of maximum value of each channel at each epoch
minepochvals = cellfun(@(x)abs(min(x,[],1)), epochCellArray, 'UniformOutput', false);
%same as above but for minimum values, this time we can't use UniformOutput as we don't have scalar output
cleanEpochs=cellfun(@(x,y)((x<thresholdValues)&(y<thresholdValues)),maxepochvals,minepochvals,'UniformOutput',false);
numArtefacts=(nEpochs*nChans)-sum(sum(cell2mat(cleanEpochs)))
percentageArtefacts=(numArtefacts./(nEpochs*nChans))*100
totalEpochs=nEpochs*nChans
%return segmented signal as well (might as well...)
segmentedSignal=mat2cell(signal,[ones(1,nEpochs)*epochLength mod(nSamples,epochLength)],[148]);
segmentedSignal(end)=[];



end
