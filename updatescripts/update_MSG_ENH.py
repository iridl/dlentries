#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import pandas as pd
import datetime
from dateutil.relativedelta import relativedelta


URL_PATH = "https://data.rda.ucar.edu/d548001/"
DEST_PATH = Path("/Data/data5/ucar/d548001")
TODAY = datetime.datetime.today()

for date in pd.date_range(
    end=TODAY.replace(day=1)+relativedelta(months=-1), periods=3, freq="MS",
):
    for res in range(1, 3):
        sub_path = f'msg302_{res}deg'
        file = f'MSG{res}_R3.0.2_ENH_{date.strftime("%Y-%m")}.tar'
        file_target = DEST_PATH / sub_path / file
        if (DEST_PATH / sub_path / file_target.stem).is_dir():
            is_downloaded = False
            print(f'Already have {file_target.stem}')
        else:
            is_downloaded, message = uu.download_file(
                (DEST_PATH / sub_path), file, f'{URL_PATH}{sub_path}/{file}',
            )
            print(message)
            if file_target.is_file():
                unpacked_dir, message = uu.unpack(
                    (DEST_PATH / sub_path / file), keep_packed_file=False,
                )
                print(message)
                for gz_file in list(unpacked_dir.glob("*.gz")):
                    unpacked_file, message = uu.unpack(gz_file, keep_packed_file=False)
                    print(message)
