
#!/bin/bash
# Enable debugging
set -x

echo "Welcome to the Riff.CC toolkit! Let's have some fun."

# Get a list of releases and map it into an array.
# We also filter to cut out ".", ".." and anything ending with .torrent,
# and ensure we only process items ending with "_librivox".
# Fortunately for us, only 360 out of 15,000+ audiobooks do not meet these criteria.
# There is a "bug" with regard to sorting. We can likely solve it by simply sorting find before
# we load it into mapfile. Thanks @nug.
mapfile -t < <(find . -maxdepth 1 -type d -name "*_librivox" -not -name "*.torrent" -not -name "." -not -name "..")

# Create a counter
counter=1

# Now let's enter the loop.
for i in "${MAPFILE[@]}"
do
	echo "We are on loop #$counter."
	counter=$((counter + 1))

	echo Processing: "$i"
	releaseName=${i:2}
	if [ -z "$releaseName" ]; then
		echo "Name is empty"
		echo "PANIK"
		echo 1336
	fi

	echo "Grabbing the title for $releaseName"
        # Fetch the title of the release
        metadata=$(curl -s "https://archive.org/metadata/$releaseName/metadata")
        sourceTitle=$(echo "$metadata" | jq -r '.result.title + " by " + .result.creator')
        echo "Title: $sourceTitle"

	if [ "$sourceTitle" == " by " ]; then
		echo "sourceTitle is empty. This means something went wrong."
		echo "Skipping and logging the issue."
		echo "Failed on $releaseName" >> ~/failures.log
	fi

	if [ "$sourceTitle" != " by " ]; then
		# Create the release folder and hard link the files in
		echo "Creating folders."
		mkdir -p "$sourceTitle" || { echo 'Failed to create folders! Exiting.' ; exit 1; }
		echo "Hard linking."
		ln "$releaseName/"* "$sourceTitle"/ 2>/dev/null
		# Cleanup unneeded files
		echo "Cleaning up unneeded files."
		rm "$sourceTitle"/*.png "$sourceTitle"/*.m4b "$sourceTitle"/*.xml "$sourceTitle"/*.sqlite "$sourceTitle"/*.json "$sourceTitle"/*.gz 2>/dev/null
		rm "$sourceTitle"/*.txt "$sourceTitle"/*.zip "$sourceTitle"/*.html "$sourceTitle"/*_itemimage.jpg "$sourceTitle"/*_thumb.jpg 2>/dev/null
		rm "$sourceTitle"/*.ogg 2>/dev/null
		# Remove lower quality mp3s
		echo "Removing lower quality mp3s."
		rm "$sourceTitle"/*_64kb.mp3 2>/dev/null
		find "$sourceTitle"/ -type f -iname "*.mp3" | grep -v _128kb.mp3 | xargs -d "\n" -I {} rm \{\} 2>/dev/null
		echo "Building the torrent!"
		~/mktorrent.sh -n "$sourceTitle" -o "$releaseName.torrent" "$sourceTitle"/
		#read -p "Press any key to keep going ..."
	fi
done
