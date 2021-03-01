#!/bin/bash
# Debugging
#set -x

# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

echo "Thanks for using Riff.CC Upload Toolkit!"

# Turn that into an array. https://stackoverflow.com/questions/9293887/reading-a-delimited-string-into-an-array-in-bash/53369525
mapfile -t < <(find . -maxdepth 1 -type f -name "*.torrent")

for torrentName in "${MAPFILE[@]}"
do
	# Debug
	echo $(basename "${torrentName:2}" .torrent)
	releaseName=$(basename "${torrentName:2}" .torrent)
	echo "release name $releaseName"
        if [ "$releaseName" == ".torrent" ]; then
                echo "Release name is empty"
                echo "PANIK"
                echo 1335
        fi
	# Fetch the name of our thing
	metadata=$(curl -s 'https://archive.org/metadata/'$releaseName'/metadata')
	sourceTitle=$(echo $metadata | jq '.result.title + " by " + .result.creator')
	echo $sourceTitle
        if [ "$sourceTitle" == '" by "' ]; then
                echo "sourceTitle is empty. This means something went wrong."
                echo "Skipping and logging the issue."
                echo "Failed on $releaseName" >> ~/failures.log
        fi
	# Fetch the description of the content and throw it into a file.
	curl -s 'https://archive.org/metadata/'$releaseName'/metadata/description' | jq '.result' | html2text -utf8 -nobs > description.tmp
        # Run the special API upload script using our params
	echo "Uploading $sourceTitle."
        echo python3 ~/upload-toolkit/fetcher/apiup-auto.py "$torrentName" "https://archive.org/details/$torrentName" "$sourceTitle" >> uploads-"$timestamp".txt
done
