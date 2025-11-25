#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path


DEST_DIR = Path(
    f'/Data/data23/UCSB/CHIRPS/v2p0/dekad/tifs/'
    f'{uu.previous_month(iter=1).strftime("%Y")}'
)
DEST_DIR.mkdir(mode=uu.DIR_MODE, parents=True, exist_ok=True)
URL_PATH = "ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_dekad/tifs"
FILE_NAME = "chirps-v2.0."
for dekad in range(1, 4):
    #Files are issued monthly by batch of 3 dekads of the previous month
    file_name = f'{FILE_NAME}{uu.previous_month(iter=1).strftime("%Y.%m")}.{dekad}.tif.gz'
    print(file_name)
    is_downloaded, message = uu.download_file(
        DEST_DIR, file_name, f'{URL_PATH}/{file_name}',
    )
    print(message)
    if is_downloaded:
        gzfile_name = DEST_DIR / file_name
        unpacked, message = uu.unpack(gzfile_name, keep_packed_file=False)
        print(message)
    else:
        print("gz file was not downloaded")
