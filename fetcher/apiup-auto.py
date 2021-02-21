import requests
import logging
import sys
import os

#print(os.getcwd())

# Enabling debugging at http.client level (requests->urllib3->http.client)
# you will see the REQUEST, including HEADERS and DATA, and RESPONSE with HEADERS but without DATA.
# the only thing missing will be the response.body which is not logged.
#try: # for Python 3
#    from http.client import HTTPConnection
#except ImportError:
#    from httplib import HTTPConnection
#HTTPConnection.debuglevel = 1

#logging.basicConfig() # you need to initialize logging, otherwise you will not see anything from requests
#logging.getLogger().setLevel(logging.DEBUG)
#requests_log = logging.getLogger("urllib3")
#requests_log.setLevel(logging.DEBUG)
#requests_log.propagate = True

headers = {'User-Agent': 'rcc-ut/1.0.1'}

test_file = open(str(sys.argv[1]), "rb")

from pathlib import Path
apitoken = Path('/home/wings/.rcc-api').read_text()
torrentdescription = Path('description.tmp').read_text()
torrentname = str(sys.argv[3]).strip('"')

print(str(sys.argv[1])+'\n\n'+torrentname+'\n\n'+str(sys.argv[2])+'\n\n'+torrentdescription)

payload = {
    'nfo':'',
    'name':torrentname,
    'description':'Testing submission via Python. \n\n Source: '+str(sys.argv[2])+'\n\n'+torrentdescription,
    'mediainfo':'',
    'category_id':'10',
    'type_id':'21',
    'resolution_id':'13',
    'user_id':'3',
    'tmdb':'0',
    'imdb':'0',
    'tvdb':'0',
    'mal':'0',
    'igdb':'0',
    'anonymous':'0',
    'stream':'0',
    'sd':'0',
    'internal':'0',
    'featured':'0',
    'free':'0',
    'doubleup':'0',
    'sticky':'0'
}

session = requests.Session()
r = session.post('https://u.riff.cc/api/torrents/upload?api_token='+apitoken,headers=headers,files = {'torrent': test_file},data=payload)

print(r.text)
