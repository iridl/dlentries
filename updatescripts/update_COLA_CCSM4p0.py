#!/usr/local/bin/condarun updatescripts2

from pathlib import Path
import update_utilities as uu
import datetime


DEST_PATH = Path("/Data/data23/NMME/CCSM4.0.D")
URL_PATH = "ftp://decadal.rsmas.miami.edu/pub/CPC_DATA/CCSM4/NMME"

VARIABLES = [
    "precip", "sst", "t_ref", "tsmn", "tsmx", "evaporation", "geop200", "runoff",
    "soilmoist", "aice", "hice", "uvel",
]

for var in VARIABLES :
    for m in range(1, 11) :
        file = f'{uu.previous_month().strftime("%Y%m%d")}.1x1.{var}_ens{m:02}.nc'
        message = uu.download_file(
            (DEST_PATH / f'{datetime.datetime.today().strftime("%b")}.D'),
            file,
            f'{URL_PATH}/{datetime.datetime.today().strftime("%m")}/{file}',
        )
        print(message)
