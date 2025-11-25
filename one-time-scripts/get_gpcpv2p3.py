#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import requests
import update_utilities as uu

URL_PATH = f'https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly/access/'
DEST_PATH = Path(f'/Data/data7/nasa/gpcp/v2p3/cdr_ncei')

for ayear in range(1979, 2025):
    files = requests.get(f'{URL_PATH}{ayear}').text
    file_name_end_idx = [n for n in range(len(files)) if files.find(".nc<", n) == n]
    file_name_char_length = 52 if ayear == 2024 else 40
    for idx in file_name_end_idx:
        file_name = files[idx-file_name_char_length+3:idx+3]
        print(file_name)
        is_downloaded, message = uu.download_file(
            DEST_PATH, file_name, f'{URL_PATH}{ayear}/{file_name}',
        )
