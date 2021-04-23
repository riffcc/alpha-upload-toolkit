#!/bin/bash
# Debugging
#set -x

# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

echo "Thanks for using Riff.CC Upload Toolkit!"

# Turn that into an array. https://stackoverflow.com/questions/9293887/reading-a-delimited-string-into-an-array-in-bash/53369525
mapfile -t < <(find . -maxdepth 1 -type f -name "*.torrent")

# Create a counter
counter=1

for torrentName in "${MAPFILE[@]}"
do
	# Debug
        echo "We are on loop #$counter."
        counter=$((counter + 1))
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
	#sourceTitle=$(echo $metadata | jq '.result.title + " by " + .result.creator')
	sourceTitle=$(echo "$metadata" | jq '.result.title + " by " + (try (.result.creator | join(", ")) catch false // .result.creator)')
	echo $sourceTitle
        if [ "$sourceTitle" == '" by "' ]; then
                echo "sourceTitle is empty. This means something went wrong."
                echo "Skipping and logging the issue."
                echo "Failed on $releaseName" >> ~/failures.log
        fi
	# Fetch the description of the content and throw it into a file.
	curl -s 'https://archive.org/metadata/'$releaseName'/metadata/description' | jq '.result' | html2text -utf8 -nobs > description-$releaseName.tmp
        # Run the special API upload script using our params
	echo "Uploading $sourceTitle."
        echo python3 ~/upload-toolkit/uploadbot/apiup-auto.py "$torrentName" "$releaseName" "https://archive.org/details/${torrentName:2}" "$sourceTitle" >> uploads-"$timestamp".txt
done
