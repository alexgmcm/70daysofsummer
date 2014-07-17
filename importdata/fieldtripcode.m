
addpath('/home/alexgmcm/Documents/MATLAB/FieldTrip/fieldtrip-20140518');
ft_defaults;
dataDir='/media/alexgmcm/Elements/mciCompleteData/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};


for i=1:length(filenames)
   strcat('Progress:',num2str(i/length(filenames)*100))
filename=filenames{i};
loadFieldTrip(filename);
[header, data_ref] = loadFieldTrip(filename);

cfg=[];
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq = [1.5 40]
cfg.bpfiltord=560;
cfg.bpfilttype='fir';



data_ref=ft_preprocessing(cfg,data_ref);


cfg = [];
cfg.length=5;%5 second epoch length
data_ref=ft_redefinetrial(cfg, data_ref);
%it seems the trl info we want (start and end samples of trls) is in data_ref.cfg.previous.trl rather than data_ref.cfg.trl


trialinfo=data_ref.cfg.previous.trl;






% cfg.artfctdef.muscle.artifact = artifact_muscle;





% jump %cutoff=89.5
cfg  = [];

cfg.trl = trialinfo;
cfg.continuous = 'yes';
 
% channel selection, cutoff and padding
cfg.artfctdef.zvalue.channel    = 'MEG';
cfg.artfctdef.zvalue.cutoff     = 60;
if i ~= 1
   cfg.artfctdef.zvalue.cutoff     = prevJumpCutoff;
end
cfg.artfctdef.zvalue.trlpadding = 0;
cfg.artfctdef.zvalue.artpadding = 0;
cfg.artfctdef.zvalue.fltpadding = 0;
 
% algorithmic parameters
cfg.artfctdef.zvalue.cumulative    = 'yes';
cfg.artfctdef.zvalue.medianfilter  = 'yes';
cfg.artfctdef.zvalue.medianfiltord = 9;
cfg.artfctdef.zvalue.absdiff       = 'yes';
 
% make the process interactive
cfg.artfctdef.zvalue.interactive = 'yes';
[cfg, artifact_jump] = ft_artifact_zvalue(cfg,data_ref);
prevJumpCutoff=cfg.artfctdef.zvalue.cutoff;




   % EOG
   cfg            = [];
   cfg.trl        = trialinfo;
   cfg.continuous = 'yes'; 
 
   % channel selection, cutoff and padding
   cfg.artfctdef.zvalue.channel     = 'MEG';
   cfg.artfctdef.zvalue.cutoff      = 30;
   if i ~= 1
   cfg.artfctdef.zvalue.cutoff     = prevEOGCutoff;
end
   cfg.artfctdef.zvalue.trlpadding  = 0;
   cfg.artfctdef.zvalue.artpadding  = 0.1;
   cfg.artfctdef.zvalue.fltpadding  = 0;
 
   % algorithmic parameters
   cfg.artfctdef.zvalue.bpfilter   = 'yes';
   cfg.artfctdef.zvalue.bpfilttype = 'but';
   cfg.artfctdef.zvalue.bpfreq     = [1 15];
   cfg.artfctdef.zvalue.bpfiltord  = 4;
   cfg.artfctdef.zvalue.hilbert    = 'yes';
 
   % feedback
   cfg.artfctdef.zvalue.interactive = 'yes';
 
   [cfg, artifact_EOG] = ft_artifact_zvalue(cfg,data_ref);
prevEOGCutoff=cfg.artfctdef.zvalue.cutoff;


cfg=[]; 
cfg.artfctdef.reject = 'complete'; % this rejects complete trials, use 'partial' if you want to do partial artifact rejection
cfg.artfctdef.eog.artifact = artifact_EOG; % 
cfg.artfctdef.jump.artifact = artifact_jump;
data_no_artifacts = ft_rejectartifact(cfg,data_ref);

saveDir='/media/alexgmcm/Elements/mciArtefactFree/';
saveDir2='/media/alexgmcm/Elements/mciArtefactInfo/';

save(strcat(saveDir,filename), 'data_no_artifacts','header','artifact_EOG','artifact_jump','-mat');
save(strcat(saveDir2,filename), 'artifact_EOG','artifact_jump','-mat');


end
