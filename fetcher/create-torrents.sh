#!/bin/bash
# Enable debugging
set -x

# Get a list of releases
mapfile -t < <(ls -1 .)

# Now let's enter the loop.
for i in "${MAPFILE[@]}"
do
	if [ -z $i ]; then
		echo "Name is empty"
		echo "PANIK"
		echo 1336
	fi
        # Fetch the title of the release
        metadata=$(curl -s 'https://archive.org/metadata/'$i'/metadata')
        sourceTitle=$(echo $metadata | jq -r '.result.title + " by " + .result.creator')
        echo $sourceTitle

	if [ sourceTitle = " by " ]; then
		echo "sourceTitle is empty. This means something went wrong."
		echo "PANIK"
		exit 1337
	fi

        # Create the release folder and hard link the files in
        mkdir "$sourceTitle"
        ln "$i/"* "$sourceTitle"/
        # Cleanup unneeded files
        rm "$sourceTitle"/*.png "$sourceTitle"/*.m4b "$sourceTitle"/*.xml "$sourceTitle"/*.sqlite "$sourceTitle"/*.json "$sourceTitle"/*.gz
        rm "$sourceTitle"/*.txt "$sourceTitle"/*.zip "$sourceTitle"/*.html "$sourceTitle"/*_itemimage.jpg "$sourceTitle"/*_thumb.jpg
        # Remove lower quality mp3s
        rm "$sourceTitle"/*_64kb.mp3
        find "$sourceTitle"/ -type f -iname "*.mp3" | grep -v _128kb.mp3 | xargs -d "\n" -I {} rm \{}
        ~/mktorrent.sh -n "$sourceTitle" -o "$i.torrent" "$sourceTitle"/
	read -p "Press any key to keep going ..."
done
