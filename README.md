MRes Summer Project - Characterising the effect of normal brain ageing on MEG recordings: a diagnostic tool?
==========================================

Notes
-------
Data consists of time vector + 148 MEG channels, sampling rate is 169.549Hz except for 300mb files which are at 678.17Hz and require downsampling etc.

Some of the data is corrupted - the corruptions are noted in filename,linenumber format in corruptions.txt, be careful not to attempt to load these lines - split the loading into bits before and after the line and then concatenate the matrices.

The data files which are ~300mb have not been downsampled, these should be low pass filtered and then take one of every 4 - the decimate function does this pretty much automatically, although it will not be identical to how the MEG hardware downsampled the others and so if the samples prove to be problematic in later analysis they should be discarded.

The channel position data is in channelinfo dir.

scpscripts dir contains commands used to copy data from master server

Amplitude of signals is usually below 1pT - units appear to be in fT

### Artefact rejection

rechazo_artefactos2.m is a rudimentary artefact rejection script that takes the signal as a whole, breaks it up into many little pieces and calculates the median maximum deviation from the mean then divides the signal into larger epochs and rejects any epoch with deviations larger than the median multiplied by some constant. This removes the ocular artefacts (i.e. blinking)

Cardiac artefact should be negligible for our purposes but can be removed by a clever process averaging over all signals and using ICA etc. if absolutely necessary

Note all signals should have the mean subtracted from them when they are loaded such that they are zero mean.

FieldTrip can do automated artefact rejection but requires the data to be loaded in the correct structure - attempted in importdata


### Filtering

Filtering should be done with a Hamming window, FIR filter with higher order (~500), filtfilt does two filters and thus avoids group delay so doesn't effect phase.

Band pass filter 1.5Hz tp 40Hz or 60Hz (if only to 40Hz then must use Notch Filter at 50Hz to remove Mains AC artefact)

fdatool in MATLAB can be used to design filters easily





Todo
---------

Artefact Rejection -> Filtering - > Calculate relative powers -> average over time and brain regions -> linear regression against age -> test on healthy -> try on diseased -> see if deviation correlates with cognitive scores

Ask Javier if when filtering will apply the filter to each epoch separately - as surely after epoch rejection we can't treat non-consecutive epochs as consecutive as this will effect the observed frequency components??