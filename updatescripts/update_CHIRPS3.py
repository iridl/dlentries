#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import pandas as pd


DEST_PATH = Path(f"/Data/data23/UCSB/CHIRPS/v3p0")
URL_PATH = f"http://data.chc.ucsb.edu/products/CHIRPS/v3.0/"
for date in pd.date_range(uu.previous_month(iter=6), uu.previous_month(), freq="ME"):
    for tres in range(0, 4):
        tres_str = "" if tres == 0 else f".{tres}"
        file = f'chirps-v3.0.{date.strftime("%Y.%m")}{tres_str}.tif'
        tres_path = "monthly" if tres == 0 else "dekads"
        dest_path = DEST_PATH / tres_path / "global" / "tifs"
        url_path = f"{URL_PATH}{tres_path}/global/tifs/"
        is_downloaded, message = uu.download_file(dest_path, file, f'{url_path}{file}')
        print(message)
