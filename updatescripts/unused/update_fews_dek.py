#!/usr/local/bin/condarun updatescripts

import requests
import zipfile
import sys
from pathlib import Path
import datetime

data_folder = {
    "sa": "africa_south",
    "wa": "africa_west",
    "w1": "africa_west",
    "e1": "africa_east",
    "e2": "africa_east",
    "ee": "africa_east",
    "ek": "africa_east",
    "el": "africa_east",
    "et": "africa_east"
}

first_dkd = {
    "sa": 28,
    "wa": 13,
    "w1": 13,
    "e1": 28,
    "e2": 7,
    "ee": 7,
    "ek": 7,
    "el": 10,
    "et": 28
}

last_dkd = {
    "sa": 15,
    "wa": 33,
    "w1": 33,
    "e1": 3,
    "e2": 21,
    "ee": 33,
    "ek": 27,
    "el": 33,
    "et": 6
}

destination_folder = {
    "sa": "saf",
    "wa": "waf",
    "w1": "waf",
    "e1": "eaf",
    "e2": "eaf",
    "ee": "eaf",
    "ek": "eaf",
    "el": "eaf",
    "et": "eaf"
}

url_path = f'https://edcftp.cr.usgs.gov/project/fews/dekadal/{data_folder[sys.argv[-1]]}/'

#today's dekad from 1 to 36
today_dkd = 3*datetime.datetime.today().month - (
    2 - min((datetime.datetime.today().day - 1)//10,2)
)

#Last file is previous dekad from today
file_dkd = (today_dkd - 2) % 36 + 1
file_y = (datetime.datetime.today().year - file_dkd//36) % 100

#Data provided only for dekads from first_dkd to last_dkd
if first_dkd[sys.argv[-1]] > last_dkd[sys.argv[-1]]:
    if file_dkd < first_dkd[sys.argv[-1]] and file_dkd > last_dkd[sys.argv[-1]]:
        print(f'no files expected for dekad {file_dkd:02}')
        sys.exit()
else:
    if file_dkd < first_dkd[sys.argv[-1]] or file_dkd > last_dkd[sys.argv[-1]]:
        print(f'no files expected for dekad {file_dkd:02}')
        sys.exit()
    
file_stem = f'w{file_y}{file_dkd:02}{sys.argv[-1]}'

url = f'{url_path}{file_stem}.zip'

dest_path = f'/Data/data6/usgs/eros/fews/dekadal/{destination_folder[sys.argv[-1]]}/'
dest = f'{dest_path}{file_stem}.zip'

if Path(dest).is_dir():
    print(f'Already got {file_stem}')
    sys.exit()

dest_directory = f'{dest_path}extract/'

with requests.get(url, stream=True, allow_redirects=True) as r:
    if r.status_code == 404:
        print(f'{file_stem} not yet available')
        sys.exit()
    else:
        r.raise_for_status()
    path = Path(dest).expanduser().resolve()
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("wb") as f:
        for chunk in r.iter_content(16*1024):
            f.write(chunk)

assert Path(dest).is_file(), 'download_failed'

Path(dest_directory).mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(dest, 'r') as zip_ref:
    zip_ref.extractall(dest_directory)
Path(dest).unlink()
Path(dest_directory).rename(Path(dest))

