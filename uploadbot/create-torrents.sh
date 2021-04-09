
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

echo "DEBUG - this is our list!"
echo "${MAPFILE[@]}"

# Create a counter
counter=1

# Now let's enter the loop.
for i in "${MAPFILE[@]}"
do
	echo "We are on loop #$counter."
	counter=$((counter + 1))

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
	sourceTitleOnly=$(echo "$metadata" | jq '.result.title')
        echo "Title: $sourceTitle"

	if [ "$sourceTitle" == " by " ]; then
		echo "sourceTitle is empty. This means something went wrong."
		echo "Skipping and logging the issue."
		echo "Failed on $releaseName" >> /home/media/failures.log
	fi

	if [ "$sourceTitle" == "" ]; then
		echo "sourceTitle is empty. This means something went wrong."
		echo "Skipping and logging the issue."
		echo "Failed on $releaseName" >> /home/media/failures.log
	fi

	if [ ! "$sourceTitle" == " by " ] && [ ! "$sourceTitle" == "" ]; then
		# Create the release folder and hard link the files in
		echo "Creating folders."
		mkdir -p "/home/media/release/$sourceTitleOnly" || { echo 'Failed to create folders! Exiting.' ; exit 1; }
		echo "Hard linking."
		cp -H "/mfsbrick.3/final1/$releaseName/"* "/home/media/release/$sourceTitleOnly"/ 2>/dev/null
		# Cleanup unneeded files
		echo "Cleaning up unneeded files."
		rm "/home/media/release/$sourceTitleOnly"/*.png "/home/media/release/$sourceTitleOnly"/*.m4b "/home/media/release/$sourceTitleOnly"/*.xml "/home/media/release/$sourceTitleOnly"/*.sqlite "/home/media/release/$sourceTitleOnly"/*.json "/home/media/release/$sourceTitleOnly"/*.gz 2>/dev/null
		rm "/home/media/release/$sourceTitleOnly"/*.txt "/home/media/release/$sourceTitleOnly"/*.zip "/home/media/release/$sourceTitleOnly"/*.html "/home/media/release/$sourceTitleOnly"/*_itemimage.jpg "/home/media/release/$sourceTitleOnly"/*_thumb.jpg 2>/dev/null
		rm "/home/media/release/$sourceTitleOnly"/*.ogg 2>/dev/null
		# Remove lower quality mp3s
		echo "Removing lower quality mp3s."
		rm "/home/media/release/$sourceTitleOnly"/*_64kb.mp3 2>/dev/null
		find "/home/media/release/$sourceTitleOnly"/ -type f -iname "*.mp3" | grep -v _128kb.mp3 | xargs -d "\n" -I {} rm \{\} 2>/dev/null
		echo "Building the torrent!"
		/home/media/mktorrent.sh -n "$sourceTitle" -o "torrents/$releaseName.torrent" "/home/media/release/$sourceTitleOnly"/
		#read -p "Press any key to keep going ..."
	fi
done
