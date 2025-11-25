#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import pandas as pd
import datetime
import xarray as xr
import tempfile
import sys

FREQ = sys.argv[-1] # weeks or months
TODAY = datetime.datetime.today()
if FREQ == "months":
    start_date = uu.previous_month(TODAY, 6)
elif FREQ == "weeks":
    start_date = TODAY - datetime.timedelta(days=14)
else:
    raise Exception(f'Argument must be "weeks" or "months" not {FREQ}')

URL_PATH = "https://ftp.cpc.ncep.noaa.gov/dcollins/SubX/CFS"
DEST_DIR = Path("/Data/SubX/NCEP/CFSv2/forecast")
ALL_DATES = pd.date_range(start_date, TODAY)
VARS = ["pr_sfc", "tas_2m", "ts", "ua_200", "va_200", "zg_200", "zg_500"]

for adate in ALL_DATES :
    for var in VARS :
        for member in range(1, 5) :
            for anhour in range(0, 24, 6) :
                file_stem = (
                    f'{var}_CFS_{adate.strftime("%d%b%Y").lower()}'
                    f'_{anhour:02}z_d00_d44_m{member:02}'
                )
                #we need to post-process file with new file name
                #so need to test on new file name to know if we already have
                #uu.donwnload_file tests whether we have the file to be downloaded
                #we remove that file if post-processing was successful
                filet = f'{file_stem}_XYT.nc'
                dest_path = (
                    DEST_DIR /
                    f'{var}_CFS' /
                    adate.strftime("%Y") /
                    adate.strftime("%m")
                )
                dest_path.mkdir(mode=uu.DIR_MODE, parents=True, exist_ok=True)
                if (dest_path / filet).is_file() :
                    is_downloaded = False
                    message = f'Already got transposed {filet}'
                else:
                    file = f'{file_stem}.nc'
                    is_downloaded, message = uu.download_file(
                        #We added a variable and year dir in our file structure
                        dest_path, file, f'{URL_PATH}/{var}/realtime/{file}',
                    )
                print(message)
                if is_downloaded :
                    #Unlimited dimension time need be first for Ingrid to read
                    try:
                        with tempfile.NamedTemporaryFile(dir=dest_path) as f:
                            datat = xr.open_dataset(dest_path / file).transpose()
                            if var in ["zg_200", "zg_500"]:
                                datat = datat.rename({var: "zg"})
                            datat.to_netcdf(f.name)
                            message = uu.add_to_dataset(
                                Path(f.name), new_path=(dest_path / filet)
                            )
                            print(message)
                        print(f'successful transposition of {file}')
                    except Exception as e:
                        print(f'transposition of {file} raised {e}')
