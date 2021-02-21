#/bin/bash
# May not be necessary.
IFS=$'\n'

# Set our API key
apikey=$(cat ~/.rcc-api)

if [ -z "$apikey" ]
then
	echo "Cannot continue without an API key. Please read docs.riff.cc"
	exit 1
fi

# Download the torrent files.
filename=$(basename "$1")

# Output the appropriate curl command to upload our content
echo "NL=$'\n'"
echo "curl -X POST -F 'torrent=@\"$(pwd)/$filename\"' -F 'nfo=' -F 'name=$3' -F 'description=Source: [url]$2[/url]. $NL$NL \"$sourceDescription\" $NL$NL Uploaded using rcc-upload-toolkit.' -F 'mediainfo=' -F 'category_id=10' -F 'type_id=21' -F 'resolution_id=13' -F 'user_id=3' -F 'tmdb=0' -F 'imdb=0' -F 'tvdb=0' -F 'mal=0' -F 'igdb=0' -F 'anonymous=0' -F 'stream=0' -F 'sd=0' -F 'internal=0' -F 'featured=0' -F 'free=0' -F 'doubleup=0' -F 'sticky=0' 'https://u.riff.cc/api/torrents/upload?api_token=$apikey'"

unset IFS
