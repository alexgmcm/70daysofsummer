function [pxxArray, fArray] = applyWelch(MEGEpoch)

		fs = 169.55;
		window = floor(2*fs);
		noverlap=ceil(0.75*window);
		nfft=max(256,2^nextpow2(length(window)));

	for i = 1:size(MEGEpoch,1)

		[pxxArray(i,:),fArray(i,:)] = pwelch(MEGEpoch(i,:),window,noverlap,nfft,fs);

	end 
end

	%[pxx(1,:),f(1,:)] = pwelch(data_no_artifacts.trial{1}(1,:),window,noverlap, max(256,2^nextpow2(length(window))),fs);