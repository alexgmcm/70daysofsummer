#!/bin/bash
while read -r filename
  do
  cp -r -- /home/alexgmcm/data/MEG_AD_Thesis/50863/"$filename" /home/alexgmcm/data/MEG_AD_Thesis/50863/mci/"$filename"
done < /home/alexgmcm/Dropbox/summerproject/importdata/mcifiles.txt