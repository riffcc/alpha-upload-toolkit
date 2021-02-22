#!/bin/bash
# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

# Switch to the appropriate directory.
cd librivox
echo "Thanks for using Riff.CC Upload Toolkit!"

# Get a list of torrents
listTorrents=$(ls *.torrent)

# Turn that into an array. https://stackoverflow.com/questions/9293887/reading-a-delimited-string-into-an-array-in-bash/53369525
arr=(`echo ${listTorrents}`);

for torrentName in "${arr[@]}"
do
	# Debug
	echo $(basename "$torrentName" .torrent)
	releaseName=$(basename "$torrentName" .torrent)
	# Fetch the name of our thing
	echo metadata=$(curl -s 'https://archive.org/metadata/'$releaseName'/metadata')
	sourceTitle=$(echo $metadata | jq '.result.title + " by " + .result.creator')
	echo $sourceTitle
	# Fetch the description of the content and throw it into a file.
	curl -s 'https://archive.org/metadata/'$sourceName'/metadata/description' | jq '.result' | html2text -utf8 -nobs > description.tmp
        # Run the special API upload script using our params
	echo "Uploading $sourceTitle."
        echo python3 ~/upload-toolkit/fetcher/apiup-auto.py "$torrentName" "https://archive.org/details/$torrentName" "$sourceTitle"
        done
done
