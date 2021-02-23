#!/bin/bash
# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

# Switch to the appropriate directory.
cd netwaves
echo "Thanks for using Riff.CC Upload Toolkit!"
echo "Grabbing a list of torrent URLs."
# Grab a list of torrent URLs from our source.
# When necessary, use a local snapshot to speed up the debug loop.
# We use -q to silence wget,
# and we output to stdout before parsing and passing to various utilities to handle the actual downloading.
#releaseNames=$(wget -O- "https://archive.org/advancedsearch.php?q=collection%3A%22netwaves%22&fl%5B%5D=downloads&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=1000000000&callback=callback&save=yes&output=rss#raw" | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }')
releaseNames=$(cat ~/upload-toolkit/fetcher/netwaves.html | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | awk 'BEGIN { FS = "/" } ; { print $5}')
mapfile -t < <(echo $releaseNames)

echo ${MAPFILE[@]}
echo ${MAPFILE[1]}
# Parse our list of releases and create a list of torrent URLs
for releaseName in "${MAPFILE[@]}"
do
	echo $releaseName
	exit 1
	echo "https://archive.org/download/"$releaseName"/"$releaseName"_archive.torrent"
done >> torrentlist-$timestamp.txt

# Now grab all those torrents.
cat torrentlist-$timestamp.txt | parallel -j 20 wget -c -x

# Second lot
timestamp=$(date +"%F-T%H.%M.%S")

releaseNames=$(wget -O- "https://archive.org/advancedsearch.php?q=collection%3A%22netwaves-bpm%22&fl%5B%5D=downloads&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=1000000000&callback=callback&save=yes&output=rss#raw" | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }')
#releaseNames=$(cat ~/upload-toolkit/fetcher/netwaves.html | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | awk 'BEGIN { FS = "/" } ; { print $5}')
mapfile -t < <(echo $releaseNames)

echo ${MAPFILE[@]}
# Parse our list of releases and create a list of torrent URLs
for releaseName in "${MAPFILE[@]}"
do
	echo $releaseName
	exit 1
	echo "https://archive.org/download/"$releaseName"/"$releaseName"_archive.torrent"
done >> torrentlist-$timestamp.txt

# Now grab all those torrents.
cat torrentlist-$timestamp.txt | parallel -j 20 wget -c -x
