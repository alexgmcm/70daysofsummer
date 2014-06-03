dataDir='~/data/ControlsMEG/';
dirData=dir(dataDir);
filenames= {dirData(3:length(dirData)).name};
errInd=1;
startRow=1;
i=1;
while i <= length(filenames) %19 is first corrupted file, use for testing
%get filename and line where error appears and then repeat from after error
	errflag=0;

 	try
 		MEGData = loadMEGData(strcat(dataDir,filenames{i}),startRow);
 		%MEGData = loadMEGData(strcat(dataDir,'AnorFC26.data'),startRow);
 	catch exception
 		rowNum=str2num(exception.message(strfind(exception.message, 'row ')+4:strfind(exception.message, ',')-2));
 		 %the message reports the row AFTER the error so we -1, but we will want to start from rowNum+1 when rerunning - no this seems wrong
 		 errors{errInd,1}=filenames{i};
 		 if startRow ~= 1
 		 	errors{errInd,2}=startRow+rowNum-1;
 		 	startRow=startRow+rowNum;
 		 else
 		 	errors{errInd,2}=rowNum;
 		 	startRow=rowNum+1;
 		 end
 		 
 		 errInd=errInd+1
 		 errflag=1;
 		 save('inprogress.mat','errors');
 		%pause
 	end
 	if errflag==0
 		i=i+1
 		startRow=1;
 		
 	end
 end
save('final.mat','errors');


%strfind(exception.message, 'row ')+4
%strfind(exception.message, ',')-2
