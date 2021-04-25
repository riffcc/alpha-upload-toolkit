#!/usr/bin/python3
# Delete unwanted files.
# This should fetch the collection name for an item from archive.org
# then determine what rules to apply.
# We need a rules/ folder, and files called like gutenberg.rules within

	for root,dirs,files in os.walk(toPath + "/" + targetdirname):
		for file in files:
			testFile = os.path.join(root,file)
			print(testFile)
			if(testFile.endswith(tuple(extensionsToRemove))):
				print("Removing (failed extension): " +testFile)
				os.unlink(testFile)

			if(testFile.endswith(tuple(qualitiesToRemove))):
				print("Removing (failed quality): " +testFile)
				os.unlink(testFile)

