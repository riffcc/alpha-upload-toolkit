#!/usr/bin/python3
# Stupid debugging and testing
# Just used during development, not a real script

import os
path = "/tmp/test/"
for root,dirs,files in os.walk(path):
	for file in files:
		print(os.path.join(root,file))
