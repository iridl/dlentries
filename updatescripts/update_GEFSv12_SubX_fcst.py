#!/usr/local/bin/condarun updatescripts

import update_utilities as uu
from pathlib import Path
import pandas as pd
import datetime


URL_PATH = "https://ftp.cpc.ncep.noaa.gov/dcollins/SubX/GEFS"
DEST_DIR = Path("/Data/SubX/EMC/GEFSv12_CPC/netcdf/forecast")
#Seems to be a 1-yr rolling archive
TODAY = datetime.datetime.today()
ALL_DATES = pd.date_range(TODAY - datetime.timedelta(days=14), TODAY)
VARS = [
    "prate_sfc","tas_2m", "zg_500",
]

for adate in ALL_DATES :
    for var in VARS :
        for member in range(31) :
            file = (
                f'{var}_GEFS_{adate.strftime("%d%b%Y").lower()}'
                f'_00z_d01_d35_m{member:02}.nc'
            )
            is_downloaded, message = uu.download_file(
                #We added a daily directory in our file structure
                DEST_DIR / adate.strftime("%Y%m%d"), file, f'{URL_PATH}/{file}',
            )
            print(message)
            if is_downloaded:
                (DEST_DIR / adate.strftime("%Y%m%d") / file).chmod(0o664)
