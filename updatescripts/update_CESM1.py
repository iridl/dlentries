#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import datetime
import update_utilities as uu

URL_PATH = f'ftp://decadal.rsmas.miami.edu/pub/CPC_DATA/CESM1/NMME'
TODAYS_MONTH = datetime.datetime.today().strftime("%m")
TODAYS_YEAR = datetime.datetime.today().strftime("%Y")
DEST_PATH = Path(f'/Data/data23/NMME/CESM1/NMME/{TODAYS_MONTH}')
PRODUCTS = [
    "aice", "evaporation", "geop200", "hice", "precip", "psl", "runoff",
    "soilmoist", "ssh", "sst", "t_ref", "tsmn", "tsmx", "uvel", "vvel",
]

for p in PRODUCTS:
    for ensm in range(1, 11):
        file_name = f'{TODAYS_YEAR}{TODAYS_MONTH}01.1x1.{p}_ens{ensm:02}.nc'
        print(file_name)
        is_downloaded, message = uu.download_file(
            DEST_PATH,
            file_name,
            f'{URL_PATH}/{TODAYS_MONTH}/{file_name}'
        )
        print(message)
