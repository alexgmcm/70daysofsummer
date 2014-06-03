function strippedFilename = stripFileExtension(filename)
	%accept string, truncate at period
	strippedFilename = filename(1:find(filename=='.')-1);

end