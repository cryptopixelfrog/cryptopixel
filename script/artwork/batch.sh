#!/usr/bin/env bash
# I have been using this on MacOSX High Sierra.


#ls *_*.gif| sort -n | 

files=$(ls *_*.gif| sort -n)

for f in $files
do
	echo "Creating artwork data - $f"
    sh artworkdata_builder.sh $f
done