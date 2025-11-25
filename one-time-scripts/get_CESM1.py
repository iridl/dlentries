#!/usr/local/bin/condarun updatescripts2

from pathlib import Path
import datetime
import update_utilities as uu
import pandas as pd

URL_PATH = f'ftp://decadal.rsmas.miami.edu/pub/CPC_DATA/CESM1/NMME'
DEST_PATH = Path(f'/Data/data23/NMME/CESM1/NMME/')
PRODUCTS = [
    "aice", "evaporation", "geop200", "hice", "precip", "psl", "runoff",
    "soilmoist", "ssh", "sst", "t_ref", "tsmn", "tsmx", "uvel", "vvel",
]

for p in PRODUCTS:
    for ensm in range(1, 11):
        for date in pd.date_range("1991-01-01", "2020-12-01", freq="ME"):
            file_name = f'{date.strftime("%Y%m")}01.1x1.{p}_ens{ensm:02}.nc'
            print(file_name)
            is_downloaded, message = uu.download_file(
                (DEST_PATH / date.strftime("%m")),
                file_name,
                f'{URL_PATH}/{date.strftime("%m")}/{file_name}',
            )
            print(message)
