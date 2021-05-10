# Deprecation notice
This repository is semi-deprecated, as work is moving towards repositories for each individual tool and use case.

It has been replaced by the following tools:

* The Sentinel handles automatic licence detection and management (and flagging content for review - or removing it - when necessary). Status: Concept.
* The Librarian handles content ingest, improvement and eventual distribution. Status: Early stage porting from this repository.
* The Liferaft finds content that is not retrievable and attempts to revive it. Status: Partial completion.
* The Director transforms what we know about content and where we find it into a pseudoAPI that can be retrieved from IPFS and rendered by our client apps. Status: Early prototyping.
* The Janitor attempts to clean up and improve metadata and existing content throughout the site, then notify The Director on the best way to allow users to stop trying to farm BONS on anything that gets orphaned. Status: Concept

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
