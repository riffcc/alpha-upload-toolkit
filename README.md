# upload-toolkit
Tools to assist with uploading to Riff.CC

Used for automating the uploads process. This is only needed if you are uploading movies and TV, or if you want to bulk create torrents using Linux.

# Instructions
## Pre-requisites
"internetarchive" python module (hint: pip3 install internetarchive)

## Linux
Start by changing "replacemewithyourkey" with your announce key. You can find it on the Upload page! Then create ~/processing and ~/processing2.

Make sure you have a recent version of mktorrent installed. Then copy mktorrent.sh to ~ and make it executable.

create-torrents.sh is used to prepare uploads.

move-torrents.sh is used to move torrent files into place to be split and then copied into watch folders

sort-torrents.sh has the special job of sorting your torrents, keeping only the best available quality of each potential upload.

Once you have used all of those scripts in that order as appropriate, you should be left with plenty of things to upload in ~/processing2. Enjoy!

If you have a bunch of MP3s to process...

exiftool -r -ext MP3 '-filename<$Track - $Title.%e' . && exiftool -r -ext MP3 '-Directory<$Artist - $Album' .

## Windows
Proper instructions on using the toolkit are coming soon, I promise.

## Credits
Many thanks to nel, nug, and mesquka.
