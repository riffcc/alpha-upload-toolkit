#!/bin/bash
# Enable debugging
set -x

# Get a list of releases
mapfile -t < <(ls -1 .)

# Now let's enter the loop.
for i in "${arr[@]}"
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
        mkdir "$i/$sourceTitle"
        ln * "$i/$sourceTitle"/
	ln -s $(pwd)/"$i/$sourceTitle" .
        # Cleanup unneeded files
        rm "$i/$sourceTitle"/*.png "$i/$sourceTitle"/*.m4b "$i/$sourceTitle"/*.xml "$i/$sourceTitle"/*.sqlite "$i/$sourceTitle"/*.json "$i/$sourceTitle"/*.gz
        rm "$i/$sourceTitle"/*.txt "$i/$sourceTitle"/*.zip "$i/$sourceTitle"/*.html "$i/$sourceTitle"/*_itemimage.jpg "$i/$sourceTitle"/*_thumb.jpg
        # Remove lower quality mp3s
        rm "$i/$sourceTitle"/*_64kb.mp3
        find "$i/$sourceTitle"/ -type f -iname "*.mp3" | grep -v _128kb.mp3 | xargs -d "\n" -I {} rm \{}
        ~/mktorrent.sh -n "$i" "$i/$sourceTitle"/
done
