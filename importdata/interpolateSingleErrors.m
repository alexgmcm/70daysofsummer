%function returnedMEGData = interpolateSingleErrors(filename, errlines);

%corruptions has data file extensions but our stuff is saved as mat so strip

filename=strcat(stripFileExtension(errors(:,1)),'.mat');
dataDir='/media/alexgmcm/Elements/completeData';
errorLines= cell2mat(errors(cell2mat(cellfun(@(x)strcmp(x,stripFileExtension(filename)),stripFileExtension(errors(:,1)),'UniformOutput',false)),2));

%using INSERTROWS insert after errline-1
