#!/usr/local/bin/condarun updatescripts

import requests
import zipfile
import sys
from pathlib import Path
import datetime

url_path = "https://edcftp.cr.usgs.gov/project/fews/dekadal/africa_west/"
dest_path = "/Data/data6/usgs/eros/fews/dekadal/waf/"
histo_dir = "historical/"
nofile = False

for file_y in range(1, 23):
    if file_y == 1:
        croplist = ["wa"]
    else:
        croplist = ["wa", "w1"]
    if file_y >= 20:
        histo_dir = ""
    for file_dkd in range(13, 34):
        for crop in croplist:
            file_stem = f'w{str(file_y).rjust(2, "0")}{str(file_dkd)}{crop}'
            url = f'{url_path}{histo_dir}{file_stem}.zip'
            dest = f'{dest_path}{histo_dir}{file_stem}.zip'
            dest_directory = f'{dest_path}{histo_dir}extract/'
            if Path(dest).is_dir():
                print(f'Already got {file_stem}')
            else:
                with requests.get(url, stream=True, allow_redirects=True) as r:
                    if r.status_code == 404:
                        print(f'{file_stem} not available')
                        nofile = True
                    else:
                        r.raise_for_status()
                    path = Path(dest).expanduser().resolve()
                    path.parent.mkdir(parents=True, exist_ok=True)
                    with path.open("wb") as f:
                        for chunk in r.iter_content(16*1024):
                            f.write(chunk)
                assert Path(dest).is_file(), 'download_failed'
                if nofile:
                    nofile = False
                    Path(dest).unlink()
                else:
                    Path(dest_directory).mkdir(parents=True, exist_ok=True)
                    with zipfile.ZipFile(dest, 'r') as zip_ref:
                        zip_ref.extractall(dest_directory)
                    Path(dest).unlink()
                    Path(dest_directory).rename(Path(dest))

