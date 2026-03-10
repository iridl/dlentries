#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import datetime
import urllib.request as urlr
import re
import shutil


URL_PATH = "https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod"
DEST_DIR = Path("/Data/data22/noaa/ncep/cfsv2/6_hourly_rotating")
TODAY = datetime.datetime.today()

# Rotating archive holds last 7 days
for adate in [(TODAY - datetime.timedelta(days=d)) for d in range(7)]:
    adate_Ymd = adate.strftime("%Y%m%d")
    for anhour in range(0, 24, 6):
        for amember in range(1, 5):
            rel_path = f"cfs.{adate_Ymd}/{anhour:02}/6hrly_grib_{amember:02}"
            dest_dir = DEST_DIR / rel_path
            url_path = f"{URL_PATH}/{rel_path}"
            try:
                with urlr.urlopen(url_path) as r:
                    if r.status != 200:
                        message = f'Trying to get {rel_path} returned status {r.status}'
                        file_names = []
                    else:
                        url_text = r.read().decode()
                        file_names = re.findall(
                            r'<a href="((?:pgbf|flxf)\d{10}.\d{2}.\d{10}.grb2)">',
                            url_text,
                        )
            except Exception as e:
                file_names = []
                message = f'Trying to get {rel_path} returned status {e}'
            for file_name in file_names:
                is_downloaded, message = uu.download_file(
                    dest_dir, file_name, f'{url_path}/{file_name}',
                )
                print(message)

# Ingrid tries to read last 2 weeks from today only
old_date = TODAY - datetime.timedelta(days=15)
old_dir = DEST_DIR / f"cfs.{old_date.strftime("%Y%m%d")}"
while old_dir.is_dir():
    shutil.rmtree(old_dir)
    old_date = old_date - datetime.timedelta(days=1)
    old_dir = DEST_DIR / f"cfs.{old_date.strftime("%Y%m%d")}"
