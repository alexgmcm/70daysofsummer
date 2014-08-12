raw=loadMEGData('~/data/ControlsMEG/AFAL38.DATA',1,inf);
MEG=raw(:,2:end);

thresholdScale=2.1; %got agreement with rechazo's scale=3
[cleanEpochs, segmentedSignal,segmentedTime,upsigbounds,lowsigbounds] =  rejectArtefacts(raw,thresholdScale);

for i=1:148
	[decisions(i,:),maxthreshold(i),minthreshold(i)]=rechazo_artefactos2(MEG(:,i));
end
decisions=decisions';


accepted=sum(sum(decisions));
total=size(decisions,1)*size(decisions,2);
rejected=total-accepted;
rejectedpercentage=(rejected/total)*100;



figure;
channel=120;
for i=(1:size(cleanEpochs,1))
	hold on;
	if cleanEpochs{i}(channel)
		plot(segmentedTime{i},segmentedSignal{i}(:,channel),'b-');
	else 
		plot(segmentedTime{i},segmentedSignal{i}(:,channel),'r-');
	end
end
plot([segmentedTime{1}(1),segmentedTime{end}(end)],[upsigbounds(channel) upsigbounds(channel) ], 'g-')

plot([segmentedTime{1}(1),segmentedTime{end}(end)],[lowsigbounds(channel) lowsigbounds(channel) ], 'g-')
title('rejectArtefacts.m thresholdscale=2.1');
print('rejArtplot.png','-dpng');

figure;
for i=(1:size(cleanEpochs,1))
	hold on;
	if decisions(i,channel)
		plot(segmentedTime{i},segmentedSignal{i}(:,channel),'b-');
	else 
		plot(segmentedTime{i},segmentedSignal{i}(:,channel),'r-');
	end
end
plot([segmentedTime{1}(1),segmentedTime{end}(end)],[maxthreshold(channel) maxthreshold(channel) ], 'g-')

plot([segmentedTime{1}(1),segmentedTime{end}(end)],[minthreshold(channel) minthreshold(channel) ], 'g-')
title('rechazoartefactos2.m thresholdscale=3');
print('rechazoplot.png','-dpng');