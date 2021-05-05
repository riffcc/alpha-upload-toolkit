# uploadbot
A crucial part of the Riff.CC Upload Toolkit, the uploadbot is a friendly little fellow that is used to automate massive upload operations.

Proper documentation coming soon, but the general idea is:

* use everything-gettorrents.sh to get the torrent files
* use create-torrents.sh to create the riff.cc torrent files
* use uploadbot-auto.sh to upload the new releases to riff.cc

# TODO
* figure out a better way to handle titles, as we may end up with multiple books in the same folder if they share a title!
* (possibly) turn author lists into "Various creators" when there is more than 2 authors
* global config
