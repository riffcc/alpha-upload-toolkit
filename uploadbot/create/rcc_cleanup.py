#!/usr/bin/python3
# Delete unwanted files.
# This will fetch the collection name for an item from archive.org
# then determine what rules to apply from the rules/*.yml files.

# Load the libraries we need
import os
import sys
import yaml
import datetime
import logging
from internetarchive import get_item

# Settings
maxlength = 250 # max length a name can be before it is truncated

# Set up logging
# TODO datestamp
logger = logging.getLogger('loggerLogger')

import datetime
now = datetime.datetime.now()

timestamp = now.strftime('%Y-%m-%d-T-%H.%M.%S')
handler = logging.FileHandler('logs/cleanup-' + timestamp + '.log')
logger.addHandler(handler)

# Set the source directory (fromPath) and the place with our releases (toPath)
fromPath="/mfsbrick.3/final1"
toPath="/mfsbrick.3/release"
dirs=os.listdir(fromPath)
print(dirs)

for download in dirs:
	print("Working on: " + download)
	logger.info("Working on: "+ download)

	# Fetch metadata from archive.org for the item, then pull out data
	item = get_item(download)
	try:
		collection = item.item_metadata['metadata']['collection']
	except:
		print("Unknown collection or error fetching collection for "+ download)
		logger.error("Failed fetching collection for: "+ download)

	try:
		title = item.item_metadata['metadata']['title']
	except:
		print("Unknown title or error fetching title for "+ download)
		logger.error("Failed fetching title for: "+ download)

	try:
		creator = item.item_metadata['metadata']['creator']
                # Check if we have a list, and convert it to a string if needed.
		if type(creator) == list:
			print("Converting creator/author list to string")
			logger.info("Converting creator/author list to string")
			creator = ", ".join(creator)
	except:
		print("Unknown creator or error fetching creator for "+ download)
		logger.error("Failed fetching creator for: "+ download)

	# Set our directory name
	targetdirname = title + " by " + creator

	# Truncate the directory name if it is too long
	targetdirname = (targetdirname[:maxlength] + '...DEBUG...') if len(targetdirname) > maxlength else targetdirname

	# Dynamically load in our magic config files
	config = yaml.safe_load(open("rules/" + collection + ".yml"))

	# Check if the config is empty
	if config is None:
		print("Failed to load config file for collection: " + collection)
		sys.exit(1338)

	if not config["extensions"] == "this_page_intentionally_left_blank":
		for root,dirs,files in os.walk(toPath + "/" + targetdirname):
			for file in files:
				testFile = os.path.join(root,file)
				print(testFile)

				if(testFile.endswith(tuple(config["extensions"]))):
					print("Removing (failed extension): " +testFile)
					logger.info("Removing (failed extension): " +testFile)
					os.unlink(testFile)

	if not config["qualities"] == "this_page_intentionally_left_blank":
		for root,dirs,files in os.walk(toPath + "/" + targetdirname):
			for file in files:
				testFile = os.path.join(root,file)
				print(testFile)

				if(testFile.endswith(tuple(config["qualities"]))):
					print("Removing (failed quality): " +testFile)
					logger.info("Removing (failed quality): " +testFile)
					os.unlink(testFile)
