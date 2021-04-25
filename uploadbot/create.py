#!/usr/bin/python3
# Python3 script to produce torrent files from existing files and folders
# This script currently only works for archive.org releases.

# Set some initial settings
extensionsToRemove = [ "HELLO", ".png", ".m4b", ".xml", ".sqlite", ".json", ".gz", ".txt", ".zip", ".html", ".jpg", "_itemimage.jpg", "_thumb.jpg", ".ogg" ]
qualitiesToRemove = [ "_64kb.mp3"]

import os
import shutil
import logging
from internetarchive import get_item


# Create a log file for the jobs.
logger = logging.getLogger('loggerLogger')

handler = logging.FileHandler('logs/test.log')
logger.addHandler(handler)

logger.warning('This is a WARNING message')
logger.error('This is an ERROR message')
logger.critical('This is a CRITICAL message')

path="/tmp/test"
dirs=os.listdir(path)
print(dirs)

for download in dirs:
	# Fetch metadata from archive.org for the item", then pull out data
	item = get_item(download)
	try:
		title = item.item_metadata['metadata']['title']
	except:
		print("Unknown title or error fetching title for "+ download)
		logger.error("Failed fetching title for: "+ download)
	try:
		creator = item.item_metadata['metadata']['creator']
	except:
		print("Unknown title or error fetching creator for "+ download)
		logger.error("Failed fetching creator for: "+ download)
	try:
		copyright = item.item_metadata['metadata']['possible-copyright-status']
	except:
		print("Unknown title or error fetching possible-copyright-status for "+ download)
		logger.error("Failed fetching possible-copyright-status for: "+ download)

	# Check that title length is not zero.

	if(not len(title)):
		print("oh dear")

	# Set our directory name
	targetdirname = title + " by " + creator

	print(targetdirname)

	logger.info("Trying to create release " + download + " as " + targetdirname)
	try:
		#os.mkdir(path + "/" + targetdirname)
		shutil.copytree(path + "/" + download, path + "/" + targetdirname, copy_function=os.link)
	except:
		print("Failed creating directory for: "+ download)
		logger.error("Failed creating directory for: "+ download)		
	print(title + " by " + creator)

	for root,dirs,files in os.walk(path + "/" + targetdirname):
		for file in files:
			testFile = os.path.join(root,file)
			print(testFile)
			if(testFile.endswith(tuple(extensionsToRemove))):
				print("Removing (failed extension): " +testFile)
				os.unlink(testFile)

			if(testFile.endswith(tuple(qualitiesToRemove))):
				print("Removing (failed quality): " +testFile)
				os.unlink(testFile)

