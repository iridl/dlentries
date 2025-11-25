#!/usr/local/bin/condarun updatescripts

import update_utilities as uu
from pathlib import Path
import datetime
import pandas as pd
import sys


PRODUCT = sys.argv[-1]
if PRODUCT not in ["forecast", "hindcast"] :
    raise Exception(f'parameter can only be forecast or hindcast and not {PRODUCT}')

URL_SUB = {"forecast": "forecast/subX_fcst", "hindcast": "reforecast/subX_refcst"}
FILE_SUB = {"forecast": "realtime", "hindcast": "reforecast"}
#Hindcasts are available 2 weeks ahead of time
DATE_OFFSET = {"forecast": 0, "hindcast": 14}
TAR_DATE_SUFX = {"forecast": "00", "hindcast": ""}
MEMBERS = {"forecast": 20, "hindcast": 4}
FIRST_MEMBER =  {"forecast": 0, "hindcast": 1}

URL_PATH = f'https://collaboration.cmc.ec.gc.ca/cmc/CMOI/GRIB/GEPS/{URL_SUB[PRODUCT]}'

DEST_DIR = Path(f'/Data/SubX/ECCC/GEPS8/{PRODUCT}')
#There is forecast data prior to 2024-06-13 but it's from GEPS7
WEEKS_OF_INTEREST = pd.date_range(
    max(
        datetime.datetime.today() - datetime.timedelta(days=7*4),
        datetime.datetime(2024, 6, 13),
    ),
    (datetime.datetime.today() + datetime.timedelta(days=DATE_OFFSET[PRODUCT])),
)
MON_THU_OF_INTEREST = WEEKS_OF_INTEREST.where(
    (WEEKS_OF_INTEREST.weekday == 0) + (WEEKS_OF_INTEREST.weekday == 3)
).dropna()

for adate in MON_THU_OF_INTEREST:
    date_str = f'{adate.strftime("%Y%m%d")}'
    dest_dir = DEST_DIR / f'{date_str}{TAR_DATE_SUFX[PRODUCT]}'
    dest_dir.mkdir(mode=uu.DIR_MODE, parents=True, exist_ok=True)
    for m in range(FIRST_MEMBER[PRODUCT], MEMBERS[PRODUCT] + 1):
        if PRODUCT == "forecast" :
            years = [int(f'{adate.strftime("%Y")}')]
        else:
            years = range(2001, 2021)
        file_names = [
            (
                f'subX_{FILE_SUB[PRODUCT]}_ECCC_'
                f'{y}{adate.strftime("%m%d")}00_m{m:02}.tar'
            ) for y in years
        ]
        for file_name in file_names :
            is_downloaded, message = uu.download_file(
                dest_dir,
                file_name,
                f'{URL_PATH}/{date_str}/{file_name}',
                expected_file_size=274636800,
            )
            print(message)
            if is_downloaded:
                tarfile_name = dest_dir / file_name
                unpacked_dir, message = uu.unpack(tarfile_name, keep_packed_file=True)
                print(message)
                # We put all members together in same dated directory
                for file in unpacked_dir.glob('*.nc'):
                    message = uu.add_to_dataset(file, new_path=(dest_dir / file.name))
                    print(message)
                unpacked_dir.rmdir()
            else:
                print("tarfile was not downloaded")
