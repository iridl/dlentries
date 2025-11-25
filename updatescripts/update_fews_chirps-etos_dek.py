#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
import zipfile
import sys
from pathlib import Path
import numpy as np
import tempfile
from collections import namedtuple


CROP_KEY = sys.argv[-1]

Crop = namedtuple('Crop', ['first_dkd', 'last_dkd', 'src_folder', 'dest_folder', 'sub_folder'])

CROPS = {
    "sa": Crop(28, 15, "southern", "saf", "southern"),
    "wa": Crop(13, 33, "west", "waf", "west"),
    "w1": Crop(13, 33, "west", "waf", "west1"),
    "e1": Crop(28, 3, "east", "eaf", "east1"),
    "e2": Crop(7, 21, "east", "eaf", "east2"),
    "ee": Crop(7, 33, "east", "eaf", "easte"),
    "ek": Crop(7, 27, "east", "eaf", "eastk"),
    "el": Crop(10, 33, "east", "eaf", "eastl"),
    "et": Crop(28, 6, "east", "eaf", "eastt"),
}

URL_PATH = (
    f'https://edcftp.cr.usgs.gov/project/fews/africa/{CROPS[CROP_KEY].src_folder}'
    f'/dekadal/wrsi-chirps-etos/{CROPS[CROP_KEY].sub_folder}'
)

#A given month, they produce the 3 dekads of the previous month
FILES_DKD = 3*uu.previous_month(iter=1).month - np.array([2, 1, 0])
FILES_Y = uu.previous_month(iter=1).year * np.array([1, 1, 1])
#Let's add the dekads of the previous month
FILES_DKD = np.append(
    3*uu.previous_month(iter=2).month - np.array([2, 1, 0]), FILES_DKD,
)
FILES_Y = np.append(
    uu.previous_month(iter=2).year * np.array([1, 1, 1]), FILES_Y,
)

for dkd in range(6) :
    file_dkd = FILES_DKD[dkd]
    file_y = FILES_Y[dkd]
    #Data provided only for dekads from FIRST_DKD to LAST_DKD
    if (
        (CROPS[CROP_KEY].first_dkd > CROPS[CROP_KEY].last_dkd)
        and (file_dkd < CROPS[CROP_KEY].first_dkd)
        and (file_dkd > CROPS[CROP_KEY].last_dkd)
    ):
        print(f'no files expected for dekad {file_dkd:02}')
    elif (
        (CROPS[CROP_KEY].first_dkd <= CROPS[CROP_KEY].last_dkd)
        and (
            (file_dkd < CROPS[CROP_KEY].first_dkd)
            or (file_dkd > CROPS[CROP_KEY].last_dkd)
        )
    ):
        print(f'no files expected for dekad {file_dkd:02}')
    else:
        file_stem = f'w{file_y}{file_dkd:02}{CROP_KEY}'
        url = f'{URL_PATH}/{file_stem}.zip'
        dest_path = Path(
            f'/Data/data6/usgs/eros/fews/dekadal/wrsi-chirps-etos/'
            f'{CROPS[CROP_KEY].dest_folder}/{CROPS[CROP_KEY].sub_folder}'
        )
        dest_dir = dest_path / file_stem
        if Path(dest_dir).is_dir():
            print(f'Already got {file_stem}')
        else:
            is_downloaded, message = uu.download_file(
                dest_path, f'{file_stem}.zip', url,
            )
            print(message)
            if is_downloaded:
                unpacked, message = uu.unpack(
                    dest_dir.with_suffix('.zip'), keep_packed_file=False,
                )
                print(message)

