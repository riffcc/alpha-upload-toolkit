#!/bin/bash
# Enable debugging
#set -x

echo "Welcome to the Riff.CC toolkit! Let's have some fun."

# Get a list of releases
mapfile -t < <(ls -1 .)

# Now let's enter the loop.
for i in "${MAPFILE[@]}"
do
	if [ -z "$i" ]; then
		echo "Name is empty"
		echo "PANIK"
		echo 1336
	fi
	echo "Grabbing the title for $i"
        # Fetch the title of the release
        metadata=$(curl -s 'https://archive.org/metadata/'$i'/metadata')
        sourceTitle=$(echo $metadata | jq -r '.result.title + " by " + .result.creator')
        echo "Title: $sourceTitle"

	if [ sourceTitle = " by " ]; then
		echo "sourceTitle is empty. This means something went wrong."
		echo "PANIK"
		exit 1337
	fi

        # Create the release folder and hard link the files in
	echo "Creating folders."
        mkdir "$sourceTitle" 2>/dev/null
	echo "Hard linking."
        ln "$i/"* "$sourceTitle"/ 2>/dev/null
        # Cleanup unneeded files
	echo "Cleaning up unneeded files."
        rm "$sourceTitle"/*.png "$sourceTitle"/*.m4b "$sourceTitle"/*.xml "$sourceTitle"/*.sqlite "$sourceTitle"/*.json "$sourceTitle"/*.gz 2>/dev/null
        rm "$sourceTitle"/*.txt "$sourceTitle"/*.zip "$sourceTitle"/*.html "$sourceTitle"/*_itemimage.jpg "$sourceTitle"/*_thumb.jpg 2>/dev/null
	rm "$sourceTitle"/*.ogg
        # Remove lower quality mp3s
	echo "Removing lower quality mp3s."
        rm "$sourceTitle"/*_64kb.mp3 2>/dev/null
        find "$sourceTitle"/ -type f -iname "*.mp3" | grep -v _128kb.mp3 | xargs -d "\n" -I {} rm \{} 2>/dev/null
	echo "Building the torrent!"
        ~/mktorrent.sh -n "$sourceTitle" -o "$i.torrent" "$sourceTitle"/
	# read -p "Press any key to keep going ..."
done
