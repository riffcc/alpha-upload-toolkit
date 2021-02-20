#/bin/bash
IFS=$'\n'

for x in *.torrent; do
	echo "Please enter the TMDB ID for the torrent $x:"
	read tmdbid

	if [ -z "$tmdbid" ]; then
		echo "No TMDB ID provided, we cannot continue."
		echo "This upload type requires one."
		exit 1;
	fi

	echo "Please enter a source for where you found the torrent:"
	read sourceURL

	if [ -z "$sourceURL" ]; then
		# We have not provided a source.
		sourceURL="Source not currently available"
	cat << EOF
curl -X POST -F 'torrent=@"$x"' -F 'nfo=""' -F 'name="${x%%.*}"' -F 'description="Source: $sourceURL. Uploaded via bulk uploader (apiup)"' -F 'mediainfo=""' -F 'category_id="1"' -F 'type_id="4"' -F 'resolution_id="13"' -F 'user_id="3"' -F 'tmdb="$tmdbid"' -F 'imdb="0"' -F 'tvdb="0"' -F 'mal="0"' -F 'igdb="0"' -F 'anonymous="0"' -F 'stream="0"' -F 'sd="0"' -F 'internal="0"' -F 'featured="0"' -F 'free="0"' -F 'doubleup="0"' -F 'sticky="0"' 'https://u.riff.cc/api/torrents/upload?api_token=SyjSAQpTu5IuuHk7kPPW0gsLb01PS2TH8kARhj5fIpwYYH9k5tFJJyKkIfICFvKdq499ZB4aj6NCx3PWfTC215MjXWfRxDryjoZT'
EOF
	else
	cat << EOF
curl -X POST -F 'torrent=@"$x"' -F 'nfo=""' -F 'name="${x%%.*}"' -F 'description="Source: [url=$sourceURL]$sourceURL[/url]. Uploaded via bulk uploader (apiup)"' -F 'mediainfo=""' -F 'category_id="1"' -F 'type_id="4"' -F 'resolution_id="13"' -F 'user_id="3"' -F 'tmdb="$tmdbid"' -F 'imdb="0"' -F 'tvdb="0"' -F 'mal="0"' -F 'igdb="0"' -F 'anonymous="0"' -F 'stream="0"' -F 'sd="0"' -F 'internal="0"' -F 'featured="0"' -F 'free="0"' -F 'doubleup="0"' -F 'sticky="0"' 'https://u.riff.cc/api/torrents/upload?api_token=EXAMPLE'
EOF
	fi
done

unset IFS

