#!/bin/bash
# Enable debugging
set -x

echo "Welcome to the Riff.CC toolkit! Let's have some fun."

# Get a list of releases and map it into an array.
# We also filter to cut out ".", ".." and anything ending with .torrent.
# There is a "bug" with regard to sorting. We can likely solve it by simply sorting find before
# we load it into mapfile. Thanks @nug.
# You can filter for "*_librivox" for example if needed
mapfile -t < <(find /mfsbrick.3/final1/ -maxdepth 1 -type d -not -wholename "/mfsbrick.3/final1/" -not -name "." -not -name ".." -printf '%P\n')

#echo "DEBUG - this is our list!"
#echo "${MAPFILE[@]}"

# Create a counter
counter=1

# Now let's enter the loop.
for i in "${MAPFILE[@]}"
do
	# Print which loop we're in
	echo "We are on loop #$counter."
	counter=$((counter + 1))
	# Print how many files exist so far
	echo "Releases: $(find ~media/release/ -maxdepth 1 -type d | wc -l)"

	echo Processing: "$i"
	releaseName=${i}
	if [ -z "$releaseName" ]; then
		echo "Name is empty"
		echo "PANIK"
		echo 1336
	fi

	echo "Grabbing the title for $releaseName"
        # Fetch the title of the release
        metadata=$(curl -s "https://archive.org/metadata/$releaseName/metadata")
        sourceTitle=$(echo "$metadata" | jq '.result.title + " by " + (try (.result.creator | join(", ")) catch false // .result.creator)')

	# Detect if the sourceTitle is empty or wrong
	if [ "$sourceTitle" == " by " ]; then
		echo "sourceTitle is empty. This means something went wrong."
		echo "Skipping and logging the issue."
		echo "Failed on $releaseName" >> /home/media/logs/failures.log
	fi

	if [ "$sourceTitle" == "" ]; then
		echo "sourceTitle is empty. This means something went wrong."
		echo "Skipping and logging the issue."
		echo "Failed on $releaseName" >> /home/media/logs/failures.log
	fi

	# Automatically trim the title if needed, to avoid issues with folder creation.
	if [ "${#sourceTitle}" -ge 150 ]; then
		sourceTitle="${sourceTitle:0:150}..."
		echo $sourceTitle
	fi
        echo "Title: $sourceTitle"

	if [ ! "$sourceTitle" == " by " ] && [ ! "$sourceTitle" == "" ]; then
		# Create the release folder and hard link the files in
		echo "Creating folders."
		mkdir -p "/home/media/release/$sourceTitle" || { echo 'Failed to create folders! Exiting.' ; exit 1; }
		echo "Hard linking."
		cp -H "/mfsbrick.3/final1/$releaseName/"* "/home/media/release/$sourceTitle"/ 2>/dev/null
		# Cleanup unneeded files
		echo "Cleaning up unneeded files."
		rm -f "/home/media/release/$sourceTitle"/*.png "/home/media/release/$sourceTitle"/*.m4b "/home/media/release/$sourceTitle"/*.xml "/home/media/release/$sourceTitle"/*.sqlite "/home/media/release/$sourceTitle"/*.json "/home/media/release/$sourceTitle"/*.gz
		rm -f "/home/media/release/$sourceTitle"/*.txt "/home/media/release/$sourceTitle"/*.zip "/home/media/release/$sourceTitle"/*.html "/home/media/release/$sourceTitle"/*_itemimage.jpg "/home/media/release/$sourceTitle"/*_thumb.jpg
		rm -f "/home/media/release/$sourceTitle"/*.ogg
		# Remove lower quality mp3s
		echo "Removing lower quality mp3s."
		rm "/home/media/release/$sourceTitle"/*_64kb.mp3 2>/dev/null
		find "/home/media/release/$sourceTitle"/ -type f -iname "*.mp3" | grep -v _128kb.mp3 | xargs -d "\n" -I {} rm \{\} 2>/dev/null
		echo "Building the torrent!"
		/home/media/mktorrent.sh -n "$sourceTitle" -o "torrents/$releaseName.torrent" "/home/media/release/$sourceTitle"
		echo "We are on loop #$(($counter- 1))"
	        echo "Torrents: $(find ~media/torrents/ -maxdepth 1 -type f | wc -l)"
	fi
done
