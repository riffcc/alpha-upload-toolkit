#!/bin/bash
# Optional debugging mode
# set -x

# Force new downloads. Does not yet work.
forcenew=true

# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

echo "Thanks for using Riff.CC Upload Toolkit!"
echo "Running at $timestamp"
collections=(
librivox
tedtalks
netwaves
netwaves-bpm
blocsonic
dustedwaxkingdom
clinicalarchives
fusion-netlabel
treetrunk
pueblo_nuevo
lostfrog
mixgalaxy-records
enough_records
irdial
monokrak
cianorbe
oloil
digital-diamonds
raretunes
tapedrugsproductionsaudio
vkrsradio
no-source
mnmnrecords
bumpfoot
bestiar-netlabel
cdc-communications
miasmah
petroglyph-music
dienstbar
ogredung
monokrak
dubophonic
irish-metal-archive
restingbell
webbed_hand
we-are-all-ghosts
hortusconclususrecords
auricular
toucan
green-field-recordings
comfort_stand
crazy-language
45rpm-records
silent-flow
jazzaria
bad-panda
mahorka
killyourownarchive
monofonicos-netlabel
derkleinegruenewuerfel
surrism-phonoethics
yesnowave
lemoness
electrotoxic
cctrax
candymind
starquakerecords
phonocake
spettrorec
genetic-trance
o2label
ekafon
afmusic
ruidemos
weisskalt-blauwarm
wm
linear-obsessional-recordings
abstrakt-reflections
12rec
eg0cide
nostressnetlabel
breathe-compilations
free-music-charts
mansarda-records
kreislauf
vulpiano-records
mastertoaster-recordings
earsheltering
labelnetlabel
on-mix
deepxrec
laverna
higherlivingrecords
experimedia
dna-production
microhertz
observatory_online
hazard_records
ear
edensonic
electro-rucini
12minuteslive
)

echo "Today, we are fetching: ${collections[@]}"
echo "Downloading a list of torrent URLs."

# Grab the lists
for i in "${collections[@]}"
do
	if [[ ! -f "collections/$i.html" ]];
	then
	# Grab a list of torrent URLs from our source.
	wget -c -O collections/$i.html "https://archive.org/advancedsearch.php?q=collection%3A%22$i%22&fl%5B%5D=downloads&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=1000000000&callback=callback&save=yes&output=rss#raw"
	fi
done

# Fetch the torrents
for i in "${collections[@]}"
do
	# Make the directories to hold the torrents
	mkdir -p grabber/$i
	cd grabber/$i

	# Parse our content list and grab a list of releases
	releaseNames=$(cat ../../collections/$i.html | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | awk 'BEGIN { FS = "/" } ; { print $5}')
	arr=(`echo ${releaseNames}`);

	# Parse our list of releases and create a list of torrent URLs
	for releaseName in "${arr[@]}"
	do
		echo "https://archive.org/download/"$releaseName"/"$releaseName"_archive.torrent"
	done >> torrentlist-$timestamp.txt

	# Now grab all those torrents.
	cat torrentlist-$timestamp.txt | parallel -j 2000 wget -c -x

	# Change to the uploadbot directory
	cd ~/upload-toolkit/uploadbot
done
