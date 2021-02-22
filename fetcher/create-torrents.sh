#!/bin/bash
# Get a list of releases
folders=$(ls -1 .)

# Turn it into an array
arr=(`echo ${folders}`);

# Now let's enter the loop.
for i in "${arr[@]}"
do
        # Fetch the title of the release
        metadata=$(curl -s 'https://archive.org/metadata/'$i'/metadata')
        sourceTitle=$(echo $metadata | jq -r '.result.title + " by " + .result.creator')
        echo $sourceTitle

        # Create the release folder and hard link the files in
        cd $i
        mkdir "$sourceTitle"
	ln -s $(pwd)/"$sourceTitle" ../
        ln * "$sourceTitle"/
        # Cleanup unneeded files
        rm "$sourceTitle"/*.png "$sourceTitle"/*.m4b "$sourceTitle"/*.xml "$sourceTitle"/*.sqlite "$sourceTitle"/*.json "$sourceTitle"/*.gz
        rm "$sourceTitle"/*.txt "$sourceTitle"/*.zip "$sourceTitle"/*.html "$sourceTitle"/*_itemimage.jpg "$sourceTitle"/*_thumb.jpg
        # Remove lower quality mp3s
        rm "$sourceTitle"/*_64kb.mp3
        find "$sourceTitle"/ -type f -iname "*.mp3" | grep -v _128kb.mp3 | xargs -d "\n" -I {} rm \{}
        ~/mktorrent.sh -n "$i" "$sourceTitle"/
        cd ..
done

mv */*.torrent .
