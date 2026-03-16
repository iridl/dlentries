#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import datetime
import urllib
import shutil
from dateutil.relativedelta import relativedelta
import pandas as pd


URL_PATH = "https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod"
DEST_DIR = Path("/Data/data22/noaa/ncep/cfsv2/6_hourly_rotating")
TODAY = datetime.date.today() + relativedelta(hour=18)

# Rotating archive holds last 7 days
for var in ["pgbf", "flxf"]:
    for astart in pd.date_range(end=TODAY, periods=7*4, freq="6h")[::-1]:
        hourly_path = f"cfs.{astart.strftime("%Y%m%d")}/{astart.strftime("%H")}"
        done_file = DEST_DIR / hourly_path / f"{var}_done"
        if done_file.is_file():
            print(f"{hourly_path} is already complete for {var}")
        else:
            is_done = True
            for amember in range(1, 5):
                mem_path = f"{hourly_path}/6hrly_grib_{amember:02}"
                dest_dir = DEST_DIR / mem_path
                url_path = f"{URL_PATH}/{mem_path}"
                try:
                    url_resp = urllib.request.urlopen(url_path)
                    is_url_path = True
                except urllib.error.HTTPError as e:
                    print(f"could not open {url_path} because of {e}")
                    is_url_path = False
                    is_done = False
                if is_url_path:
                    if amember == 1 :
                        # 1st members lead up to 
                        # 0th hour of first day 7 months later
                        last_L = astart + relativedelta(months=7, day=1, hour=0)
                    elif astart.hour == 0 :
                        # Midnight starts other than for 1st member lead up to 
                        # 0th hour of first day 4 months later
                        last_L = astart + relativedelta(months=4, day=1, hour=0)
                    else:
                        # All other (ie not 1st member not midnight starts) lead up to 
                        # 45 days
                        last_L = astart + relativedelta(days=45)
                    for L_date in pd.date_range(start=astart, end=last_L, freq="6h"):
                        file_name = (
                            f"{var}{L_date.strftime("%Y%m%d%H")}."
                            f"{amember:02}.{astart.strftime("%Y%m%d%H")}.grb2"
                        )
                        print(file_name)
                        download_status = uu.download_file(
                            dest_dir, file_name, f'{url_path}/{file_name}',
                        )
                        print(download_status["message"])
                        is_done = is_done and (download_status["flag"] >= 0)
            if is_done:
                done_file.touch(mode=uu.FILE_MODE)

# Ingrid tries to read last 2 weeks from today only
old_date = TODAY - datetime.timedelta(days=15)
old_dir = DEST_DIR / f"cfs.{old_date.strftime("%Y%m%d")}"
while old_dir.is_dir():
    shutil.rmtree(old_dir)
    old_date = old_date - datetime.timedelta(days=1)
    old_dir = DEST_DIR / f"cfs.{old_date.strftime("%Y%m%d")}"
