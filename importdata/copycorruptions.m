uniqueFiles=unique(errors(:,1));
for i=1:length(uniqueFiles)
filename=stripFileExtension(uniqueFiles{i});
copyfile(strcat('/media/alexgmcm/Elements/completeData/', filename ,'.mat'), strcat('/media/alexgmcm/Elements/corruptedData/', filename ,'.mat'));
end