%Finish making the feature vectors by averaging the relative powers into brain regions
%and adding them to the age and gender information

% % Definition of the regions
% CHANNELS_CENTRAL = [1:29];
% CHANNELS_ANTERIOR = [30:32 48:52 69:74 92:94];
% CHANNELS_LEFT_LAT = [33:37 53:57 75:80 95:100 113:118 131:136];
% CHANNELS_POSTERIOR = [38:42 58:63 81:85 101:106 119:124 137:142];
% CHANNELS_RIGHT_LAT = [43:47 64:68 86:91 107:112 125:130 143:148];

dataDir='/media/alexgmcm/Elements/relativePowersPerChan/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};
load('useHealthySubjects.mat'); %loads metadata in healthySubjects 220x3 cell array
%the index for healthysubjects is the same as that for filenames so should be easy to construct feature vector in one loop
%feature vector: filename age isMale centralpowers anteriorpowers left_latpowers posteriorpowers right_latpowers
%powers go in order: deltarp thetarp alpharp beta1rp beta2rp gammarp
featureVector = [healthySubjects cell(220, 30)];

for i=1:length(filenames)

	load(strcat(dataDir,filenames{i}));
	central=mean(relativePowersPerChan(1:29,:) ,1);

	anterior=mean([ relativePowersPerChan(30:32,:); relativePowersPerChan(48:52,:); ...
	 relativePowersPerChan(69:74,:); relativePowersPerChan(92:94,:)],1);

	left_lat=mean([ relativePowersPerChan(33:37,:); relativePowersPerChan(53:57,:); relativePowersPerChan(75:80,:); ...
	 relativePowersPerChan(95:100,:); relativePowersPerChan(113:118,:); relativePowersPerChan(131:136,:)],1);

	posterior=mean([ relativePowersPerChan(38:42,:); relativePowersPerChan(58:63,:); relativePowersPerChan(81:85,:); ...
	 relativePowersPerChan(101:106,:); relativePowersPerChan(119:124,:); relativePowersPerChan(137:142,:)],1);

	right_lat=mean([ relativePowersPerChan(43:47,:); relativePowersPerChan(64:68,:); relativePowersPerChan(86:91,:); ...
	 relativePowersPerChan(107:112,:); relativePowersPerChan(125:130,:); relativePowersPerChan(143:148,:)],1);

	featureVector(i, 4:33) = num2cell([central anterior left_lat posterior right_lat]);

end

save('featureVector.mat','featureVector', '-mat');
