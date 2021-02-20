#!/bin/bash
# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

# Switch to the appropriate directory.
cd librivox
echo "Thanks for using Riff.CC Upload Toolkit!"
# Loop through as many pages as you would like.
for i in {1}
do
	echo "Grabbing a list of torrent URLs."
        # Grab a list of torrent URLs from our source.
        torrent=$(wget -q -O- "https://archive.org/advancedsearch.php?q=collection%3A%22librivoxaudio%22&fl%5B%5D=downloads&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=50&page=$i&callback=callback&save=yes&output=rss#raw" | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' |parallel links -dump -html-numbered-links 1 | grep -o 'https://archive.org/.*torrent$' | sort -u)

        # Create a list of source URLs from the torrent URLs.
        sources=$(echo "$torrent" | awk 'BEGIN { FS = "/" } ; { print $5}')

        # Turn that into an array. https://stackoverflow.com/questions/9293887/reading-a-delimited-string-into-an-array-in-bash/53369525
        arr=(`echo ${torrent}`);

        # Loop through the array and create a report of sources.
        for torrentURL in "${arr[@]}"
        do
                # Download the torrent file
		echo "Downloading $torrentURL"
                wget -q "$torrentURL" --content-disposition
                # Set the torrent filename from our torrent URL
                torrentFilename=$(basename "$torrentURL")
                # Set the name of the source we are working with
                sourceName=$(echo "$torrentURL" | awk 'BEGIN { FS = "/" } ; { print $5}')
		# Ugly hack to fetch the title of the source from its page. <3 nel!
		IFS=
		sourceTitle=$(wget -qO- "https://archive.org/details/$sourceName" | grep "<title>" | sed 's/    <title>//; s/:/by/ ; s/ : Free Download, Borrow, and Streaming : Internet Archive<\/title>// ')
                # Run the special API upload script using our params
		echo "Creating upload command in uploads.txt"
                bash ~/upload-toolkit/fetcher/apiup-auto.sh "$torrentFilename" "https://archive.org/details/$sourceName" "$sourceTitle" >> uploads-"$timestamp".txt
		echo >> uploads-"$timestamp".txt
        done
done
