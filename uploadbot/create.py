#!/usr/bin/python3
# Python3 script to produce torrent files from existing files and folders
import os
from internetarchive import get_item

path="/tmp/test"
dirs=os.listdir(path)
print(dirs)

for download in dirs:
	item = get_item(download)
	try:
		title = item.item_metadata['metadata']['title']
	except:
		print("Unknown title or error fetching title for "+ download)
	try:
		creator = item.item_metadata['metadata']['creator']
	except:
                print("Unknown title or error fetching creator for "+ download)
	try:
		copyright = item.item_metadata['metadata']['possible-copyright-status']
	except:
                print("Unknown title or error fetching possible-copyright-status for "+ download)
	if(not len(title)):
		print("oh dear")
	print(title + " by " + creator)

