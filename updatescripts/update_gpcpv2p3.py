#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import urllib.request as urlr
import update_utilities as uu
import re

URL_PATH = f'https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly/access/'
DEST_PATH = Path(f'/Data/data7/nasa/gpcp/v2p3/cdr_ncei')

# Final version is 3 months behind whereas preliminary is last month
PRODUCTS = {"gpcp_v02r03_monthly_d" : 3, "gpcp_v02r03-preliminary_monthly_d" : 1}

for p in PRODUCTS:
    latest_url = f'{URL_PATH}{uu.previous_month(iter=PRODUCTS[p]).year}'
    with urlr.urlopen(latest_url) as r:
        if r.status != 200:
            print(f'Trying to get {latest_url} returned status {r.status}')
        else:
            last_url_text = r.read().decode()
            file_names = re.findall(r""+p+"\d{6}_c\d{8}\.nc", last_url_text)[::2]
            for file_name in file_names:
                print(file_name)
                is_downloaded, message = uu.download_file(
                    DEST_PATH, file_name, f'{latest_url}/{file_name}',
                )
                print(message)
