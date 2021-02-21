#!/bin/bash
# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

# Check if no numbers were provided.

if [ -z "$1" ] || [ -z "$2" ]
then
	echo "Please provide a starting and ending page in the RSS feed."
	echo "Exiting..."
	exit 1
fi

# Check if the provided values are actually numbers.
case $1 in
    '' | *[!0123456789]*)
        printf '%s\n' "$0: $var: invalid digit" >&2; exit 1;;
esac

case $2 in
    '' | *[!0123456789]*)
        printf '%s\n' "$0: $var: invalid digit" >&2; exit 1;;
esac


# Switch to the appropriate directory.
cd librivox
echo "Thanks for using Riff.CC Upload Toolkit!"
# Loop through as many pages as you would like.
for (( i = $1; i <= $2; ++i ));
do
	echo "Grabbing a list of torrent URLs."
        # Grab a list of torrent URLs from our source.
	# When necessary, use a local snapshot to speed up the debug loop.
        #torrent=$(cat /home/wings/upload-toolkit/fetcher/test.html | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' |parallel links -dump -html-numbered-links 1 | grep -o 'https://archive.org/.*torrent$' | sort -u)

        torrent=$(wget -q -O- "https://archive.org/advancedsearch.php?q=collection%3A%22librivoxaudio%22&fl%5B%5D=downloads&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=50&page=$i&callback=callback&save=yes&output=rss#raw" | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | parallel links -dump -html-numbered-links 1 | grep -o 'https://archive.org/.*torrent$' | sort -u)

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
		# Fetch the title of the source from its page. <3 nel!
		IFS=
		metadata=$(curl -s 'https://archive.org/metadata/'$sourceName'/metadata')
		sourceTitle=$(echo $metadata | jq '.result.title + " by " + .result.creator')
		# Fetch the description of the content and throw it into a file.
		curl -s 'https://archive.org/metadata/'$sourceName'/metadata/description' | jq '.result' | html2text -utf8 -nobs > description.tmp
                # Run the special API upload script using our params
		echo "Uploading $sourceTitle."
                python3 ~/upload-toolkit/fetcher/apiup-auto.py "$torrentFilename" "https://archive.org/details/$sourceName" "$sourceTitle" 
		unset IFS
        done
done
