#!/usr/local/bin/condarun updatescripts

import earthaccess
from pathlib import Path
import tempfile
import sys

TIME_RES = sys.argv[-1]

PATH = {"d" : "daily", "m" : "monthly"}

SHORT_NAME = {"d" : "GPCPDAY", "m" : "GPCPMON"}

DEST_PATH = Path(f'/Data/data7/nasa/gpcp/v3p2/{PATH[TIME_RES]}')

#EULA: NASA GESDISC DATA ARCHIVE
#https://urs.earthdata.nasa.gov/profile
AUTH = earthaccess.login()

RESULTS = earthaccess.search_data(short_name=SHORT_NAME[TIME_RES], version="3.2")

if len(RESULTS) != 0 :
    with tempfile.TemporaryDirectory(dir=DEST_PATH) as temp_dir:
        download_files = earthaccess.download(RESULTS, local_path=temp_dir)
        for file in download_files :
            print(file)
            Path(file).chmod(0o664)
            Path(file).rename(DEST_PATH / Path(file).name)

