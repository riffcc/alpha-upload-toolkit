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
gutenberg
librivoxaudio
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
starquakerecords
phonocake
spettrorec
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
dna-production
microhertz
observatory_online
hazard_records
ear
edensonic
electro-rucini
12minuteslive
yourselfpresents
thecoffeehouse
andreacallard
groove_tv
omskartcollective
TheOpenStage
tapedrugsproductionsaudio
vidding-fanvid
compromisebroadcasting
punkcast
pixelflowers
poohBot
thisorthat
demolitionkitchenvideo
ElectricSheep
nickfoxgieganimation
more_animation
buildingtechnologyheritagelibrary
imslp
tomlehrersongs
fav-oldsongbooks
state-foia-dump
publicsafetycode
us_house_hearings
thevenonafiles
caldocs
nsacryptolog
acus
cia-czech-lessons
todayinhistory
isoc-live
makani-power
tech-news-today
digitaltippingpoint
the_totally_rad_show
pyconza2020-Modern-javascript-re-encoded
tekzilla
hak5show
crankygeeks
destructoid
retromallorca
nsfw_show
dl-tv
coscup
filmstate_rev3
diggnationseries
tekzilla-daily
dukeplaysgames
programmingpractice
geekbeattvreviews
multicasting
soldierknowsbest
linuxactionshow
technobuffalo
netatnight
appjudgment
thisweekincomputerhardware
geekbeattv
hdnation
hantslug
CLUGtalks
toplap
factorfictional
ruminagashima
seunghwanseo
ruixianfan
kailiu
ivanmontano
basaktaner
muttukumar
jamilajad
pierrevallee
edithkaphuka
mingmarlama
raelfeliciano
laraaragon
zhannadosmailova
abhaysingh
dadah
prakashsingh
jamesbullock
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

	# Parse our content list and grab a list of releases, then count it
	releaseNames=$(cat ../../collections/$i.html | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | awk 'BEGIN { FS = "/" } ; { print $5}' | wc -l)
	echo $releaseNames

	# Change to the uploadbot directory
	cd ~/upload-toolkit/uploadbot
done
