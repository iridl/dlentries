#!/usr/local/bin/condarun updatescripts2

import urllib.request as urlr
import re
import datetime
from dateutil.relativedelta import *
import update_utilities as uu
from pathlib import Path


DATA_URL = "https://www.ncei.noaa.gov/pub/data/cirs/climdiv/"
TODAYS_MONTH = datetime.datetime.today().strftime("%Y%m")
DEST_DIR = Path("/Data/data7/noaa/ncdc/cirs/nClimDiv/v1__1")

with urlr.urlopen(DATA_URL) as r:
    if r.status != 200:
        raise Exception(f'Trying to get {DATA_URL} returned status {r.status}')
    url_text = r.read().decode()
    file_names = re.findall(
        (
            r'<a href="(climdiv-'
            r'(?:cddc|hddc|pcpc|pdsi|phdi|pmdi|sp01|sp02|'
            r'sp03|sp06|sp09|sp12|sp24|tmax|tmin|tmpc|zndx)'
            r'(?:st|cy|dv)-v1\.0\.0-\d{6}(?!\(%s\))\d{2})' % TODAYS_MONTH
        ),
        url_text,
    )
for file_name in file_names :
    is_downloaded, message = uu.download_file(
        DEST_DIR, file_name, f"{DATA_URL}{file_name}"
    )
    print(message)
    if is_downloaded :
        #file_name is e.g. climdiv-pcpndv-v1.0.0-20250206
        #dl_file will link to it, be read by DL and be stripped of -date, e.g.
        #climdiv-pcpndv-v1.0.0
        dl_file = (DEST_DIR / file_name[:-9])
        if dl_file.is_file() :
            dl_file.unlink() 
        dl_file.symlink_to(DEST_DIR / file_name)
