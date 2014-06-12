%function to load alzheimers style data - also need it to load the ControlsMEG in different_format
function [MEGData] = loadDiffFormat(str(directoryName));

%get number of lines to shape array
%will have shape [numlines x 149] (148 MEG chans + timevec)

%get length of signal (i.e. number of lines)
%use timevec to get numlines
	dataDir='~/data/ControlsMEG/different_format/';
	[status, result] = system( ['wc -l ', strcat(dataDir,directoryName, '/T/',directoryName,'_A0_0.dat')] );
	numlinesstr = regexp(result, '(^[0-9]+)?', 'match');
	numlines = str2num( numlinesstr{1,1} );

	delimiter = '';
	formatSpec = '%f%[^\n\r]';
    startRow = 1;
    endRow = inf;



	MEGData=zeros(numlines,149);
	
	numFormat='%03.0f';
	%for some reason the directory 58 in different_format has a slightly different format to the other subdirs...
	if directoryName=='58'
		numFormat='%3.0f';
	end

	for i=1:149
			if i==1
				filename =strcat(dataDir,directoryName,'/T/',directoryName,'_A',num2str(i-1,numFormat),'_0.dat');
			else
				filename=strcat(dataDir,directoryName,'/A',num2str(i-1,numFormat),'/',directoryName,'_A',num2str(i-1,numFormat),'_0.dat');
			end
		fileID = fopen(filename,'r');
		dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
		for block=2:length(startRow)
		    frewind(fileID);
		    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
		    dataArray{1} = [dataArray{1};dataArrayBlock{1}];
		end
		fclose(fileID);
		MEGData(:,i) = dataArray{:, 1};

	end
end