#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import pandas as pd
import sys


TRES = sys.argv[1] # monthly, dekads

DEST_PATH = Path(f"/Data/data23/UCSB/CHIRPS/v3p0/{TRES}/global/tifs")
URL_PATH = f"http://data.chc.ucsb.edu/products/CHIRPS/v3.0/{TRES}/global/tifs/"
for date in pd.date_range("1981-01-01", "2024-12-01", freq="ME"):
    if TRES == "monthly" :
        file = f'chirps-v3.0.{date.strftime("%Y.%m")}.tif'
        is_downloaded, message = uu.download_file(
            DEST_PATH, file, f'{URL_PATH}{file}'
        )
        print(message)
    else:
        for dkd in range(1, 4):
            file = f'chirps-v3.0.{date.strftime("%Y.%m")}.{dkd}.tif'
            is_downloaded, message = uu.download_file(
                DEST_PATH, file, f'{URL_PATH}{file}'
            )
            print(message)
