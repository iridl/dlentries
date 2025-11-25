#!/usr/local/bin/condarun updatescripts2

from pathlib import Path
import update_utilities as uu
import sys
import pandas as pd
import datetime
import gzip


TIME_RES = sys.argv[-1] # 3HLY or DLY_00Z
COMMON_PATH = "CMORPH_V0.x/RAW"
RES_PATH = f'0.25deg-{TIME_RES}'
DEST_PATH = Path("/Data/data6/noaa/cpc/cmorph") / COMMON_PATH / RES_PATH
URL_PATH = f'ftp://ftp.cpc.ncep.noaa.gov/precip/{COMMON_PATH}/{RES_PATH}'
TODAY = datetime.date.today()

for date in pd.date_range(TODAY - datetime.timedelta(days=10), TODAY):
    TIME_PATH = f'{date.strftime("%Y")}/{date.strftime("%Y%m")}'
    dest_path = DEST_PATH / TIME_PATH
    url_path = f'{URL_PATH}/{TIME_PATH}'
    file_stem = f'CMORPH_V0.x_RAW_{RES_PATH}_{date.strftime("%Y%m%d")}'
    if (dest_path / f'{file_stem}.gz').is_file():
        #We ultimately save a gz file
        is_downloaded = False
        print(f'Already have {file_stem}.gz')
    else:
        is_downloaded, message = uu.download_file(
            #Providers provides bz2 files
            dest_path, f'{file_stem}.bz2', f'{url_path}/{file_stem}.bz2'
        )
        print(message)
        if is_downloaded:
            unpacked_file, message = uu.unpack(
                (dest_path / f'{file_stem}.bz2'), keep_packed_file=False
            )
            print(message)
            if unpacked_file.is_file():
                #We compress back to gz to match historical files and save space
                gz_file = unpacked_file.parent / f'{unpacked_file.name}.gz'
                try:
                    with open(unpacked_file, 'rb') as uf:
                        with gzip.open(gz_file, 'wb') as gzf:
                            gzf.write(uf.read())
                    print(f'gzip-compressed {file_stem}')
                except Exception as e:
                    message = (
                        f'failed to gz-compress {unpacked_file} with exception {e}'
                    )
                unpacked_file.unlink()
                