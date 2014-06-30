dataDir='/media/alexgmcm/Elements/completeData/'; %set data directory
load('corruptions.mat'); %load the corruption info in errors cell array

dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};


healthySubjects=cell(length(filenames),3);
healthySubjects(:,1)=filenames(:,1);


T = cell2table(healthySubjects,'VariableNames',{'Filename','Age','isMale'});
writetable(T,'healthySubjects.txt');