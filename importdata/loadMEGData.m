function MEGData = loadMEGData(filename,startRow)
%set delimiter as tab
delimiter = '\t';

%We have 149 columns (timevec + 148 MEG channels) - all of which are to be loaded as floats.
formatSpec=repmat('%f',1,150);

%Read whole file
if nargin ==1
 	startRow = 1;
 end
 endRow = inf;

%% Open the text file.
fileID = fopen(filename,'r');


%% Read columns of data according to format string.

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

MEGData = [dataArray{1:end-1}];
