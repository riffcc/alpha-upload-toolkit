#!/bin/bash
# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

# Switch to the appropriate directory.
cd librivox
echo "Thanks for using Riff.CC Upload Toolkit!"
echo "Grabbing a list of torrent URLs."
# Grab a list of torrent URLs from our source.
# When necessary, use a local snapshot to speed up the debug loop.
# We use -q to silence wget,
# and we output to stdout before parsing and passing to various utilities to handle the actual downloading.
#releaseNames=$(wget -O- "https://archive.org/advancedsearch.php?q=collection%3A%22librivoxaudio%22&fl%5B%5D=downloads&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=1000000000&callback=callback&save=yes&output=rss#raw" | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | parallel links -dump -html-numbered-links 1 | grep -o 'https://archive.org/.*torrent$' | sort -u | head -n $1 | parallel wget -c -x)
releaseNames=$(cat ~/upload-toolkit/fetcher/librivox.html | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | awk 'BEGIN { FS = "/" } ; { print $5}')
arr=(`echo ${releaseNames}`);

# Parse our list of releases and create a list of torrent URLs
for releaseName in "${arr[@]}"
do
	echo "https://archive.org/download/"$releaseName"/"$releaseName"_archive.torrent"
done >> torrentlist-$timestamp.txt

# Now grab all those torrents.
cat torrentlist-$timestamp.txt | parallel -j 20 wget -c -x
