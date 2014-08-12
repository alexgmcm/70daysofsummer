load ./workspaces/110614.mat;
load ControlsMEGinfo.mat;

strippedFilenames=cellfun(@stripFileExtension,filenames(:,1),'UniformOutput',false);
lowerControlsMEGinfo = cellfun(@lower,ControlsMEGinfo(:,1),'UniformOutput',false);
lowerstrippedFilenames=cellfun(@lower,strippedFilenames(:,1),'UniformOutput',false);
indices=cellfun(@(x)ismember(x,lowerControlsMEGinfo(:,1)),lowerstrippedFilenames,'UniformOutput',false);
indices2=cellfun(@(x)ismember(x,lowerstrippedFilenames(:,1)),lowerControlsMEGinfo(:,1),'UniformOutput',false);
lowerstrippedFilenames(cell2mat(indices));



T = cell2table(indirnotinxls,'VariableNames',{'Filename'});
writetable(T,'indirnotinxls.txt');


T = cell2table(inxlsnotindir,'VariableNames',{'Filename'});
writetable(T,'inxlsnotindir.txt');