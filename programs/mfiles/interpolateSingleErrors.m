%function returnedMEGData = interpolateSingleErrors(filename, errlines);

%corruptions has data file extensions but our stuff is saved as mat so strip
load('corruptions.mat');
filename=strcat(stripFileExtension(errors{4,1}),'.mat');
dataDir='/media/alexgmcm/Elements/completeData/';
errorLines= cell2mat(errors(cell2mat(cellfun(@(x)strcmp(stripFileExtension(x),stripFileExtension(filename)),errors(:,1),'UniformOutput',false)),2));
load(strcat(dataDir, filename));
%using INSERTROWS insert after errline-1
gaps=zeros(length(errorLines-1),1);
for i=1:length(errorLines)-1
	gaps(i)=errorLines(i+1)-errorLines(i);
end
isConsecutive=(gaps==1);
%say the 1 in isConsecutive is at index 3, then indexes 3 and 4 in errorLines are consecutive.
%therefore we can do something like if i is consecutive?
insertData = [];
insertPositions = [];
i=1;
while i<=length(errorLines)
	if i ~= length(errorLines)
		if ~isConsecutive(i)
			insertData = [insertData; ((MEGData(errorLines(i),:)+MEGData(errorLines(i)-1,:))./2)];
			insertPositions = [insertPositions errorLines(i)-1];
		end
	else
		if ~isConsecutive(i-1)
			insertData = [insertData; ((MEGData(errorLines(i),:)+MEGData(errorLines(i)-1,:))./2)];
			insertPositions = [insertPositions errorLines(i)-1];	
		end
	end
	i=i+1






