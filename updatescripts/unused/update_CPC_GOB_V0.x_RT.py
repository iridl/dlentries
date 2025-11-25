#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import pandas as pd
import datetime


DEST_DIR = Path("/Data/data21/noaa/ncep/cpc/GOB/v0px/RT")
URL_PATH = "ftp://ftp.cpc.ncep.noaa.gov/precip/xie/CPC_GOB_V0.x/RT"
TODAY = datetime.date.today()

for date in pd.date_range(TODAY - datetime.timedelta(days=30), TODAY):
    file_name = f'CPC_GOB_V0.x_DLY_0.25deg.lnx.{date.strftime("%Y%m%d")}.RT.gz'
    is_downloaded, message = uu.download_file(
        (DEST_DIR / f'{date.year}'),
        file_name,
        f'{URL_PATH}/{date.year}/{file_name}',
    )
    print(message)
