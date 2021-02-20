wget -O- https://archive.org/services/collection-rss.php?collection=opensource_audio | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' |parallel links -dump -html-numbered-links 1 | grep -o 'https://archive.org/.*torrent$' | sort -u | parallel echo wget -x


