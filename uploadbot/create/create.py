#!/usr/bin/python3
# Python3 script to produce torrent files from existing files and folders
# This script currently only works for archive.org releases.
# It calls 3 helper scripts.

# Import everything we will need
import os
import shutil
import logging
from internetarchive import get_item

#import rcc_hardlinks
import rcc_cleanup
# import rcc_torrent
