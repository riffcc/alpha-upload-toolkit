#!/usr/bin/python3
# Python3 script to produce torrent files from existing files and folders
# This script currently only works for archive.org releases.
import os
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
	# Fetch metadata from archive.org for the item, then pull out data
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

	logger.info("Trying to create release " + download + " as " + targetdirname)
	try:
		os.mkdir(path + "/" + targetdirname)
	except:
		print("Failed creating directory for: "+ download)
		logger.error("Failed creating directory for: "+ download)		
	print(title + " by " + creator)
