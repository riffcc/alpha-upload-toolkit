#!/usr/bin/python3
# Create perfect hard linked copies of the files contained in each release.

# Settings
maxlength = 210 # max length a name can be before it is truncated

# Import needed libraries
import os
import time
import shutil
import logging
from internetarchive import get_item

# Grab the start time for the script
startTime = time.time()

# Set the source directory (fromPath) and the place we want to build our releases (toPath)
fromPath="/mfsbrick.3/final1"
toPath="/mfsbrick.3/release"
dirs=os.listdir(fromPath)
print(dirs)

# Set up logging
logger = logging.getLogger('loggerLogger')

import datetime
now = datetime.datetime.now()

timestamp = now.strftime('%Y-%m-%d-T-%H.%M.%S')
handler = logging.FileHandler('logs/hardlinks-' + timestamp + '.log')
logger.addHandler(handler)

for download in dirs:
	print("Working on: " + download)
	# Fetch metadata from archive.org for the item", then pull out data
	item = get_item(download)
	try:
		title = item.item_metadata['metadata']['title']
	except:
		print("Unknown title or error fetching title for "+ download)
		logger.error("Failed fetching title for: "+ download)
	try:
		creator = item.item_metadata['metadata']['creator']
		# Check if we have a list, and convert it to a string if needed.
		if type(creator) == list:
			creator = ", ".join(creator)
	except:
		print("Unknown title or error fetching creator for "+ download)
		logger.error("Failed fetching creator for: "+ download)
	try:
		copyright = item.item_metadata['metadata']['possible-copyright-status']
	except:
		print("Unknown title or error fetching possible-copyright-status for "+ download)
		logger.error("Failed fetching possible-copyright-status for: "+ download)

	# Check that title length is not zero and bail if it isn't
	if(not len(title)):
		print("CRITICAL: Title length is zero for "+download)
		sys.exit(1337)

	# Set our directory name
	targetdirname = title + " by " + creator

	# Truncate the directory name if it is too long
	targetdirname = (targetdirname[:maxlength] + '...DEBUG...') if len(targetdirname) > maxlength else targetdirname

	print("Trying to create release " + download + " as \"" + targetdirname + "\"")
	logger.info("Trying to create release " + download + " as " + targetdirname)
	try:
		shutil.copytree(fromPath + "/" + download, toPath + "/" + targetdirname, copy_function=os.link)
	except Exception as Argument:
		print("Failed creating directory for: "+ download)
		logger.error("Failed creating directory for: "+ download)
		logging.exception("Error occured while creating directory")
	# DEBUG
	#shutil.copytree(fromPath + "/" + download, toPath + "/" + targetdirname, copy_function=os.link)
	#print(title + " by " + creator)

print("Run started at "+ timestamp +" is now complete! Thanks for playing!")
executionTime = (time.time() - startTime)
print('Execution time in seconds: ' + str(executionTime))
