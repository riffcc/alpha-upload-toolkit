#!/usr/bin/python3
# Stupid debugging and testing
# Just used during development, not a real script

import os
from internetarchive import get_item

item = get_item('aarresaari44339gut')
print(item.item_metadata['metadata']['creator'])
