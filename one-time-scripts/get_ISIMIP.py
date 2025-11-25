#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import update_utilities as uu


DEST_PATH = Path("/Data/data24")

with open('filelist_ISIMIP.txt') as fli:
    files = fli.readlines()

for file in files:
    print(file)
    file_tree = file.strip().split("/")
    dest_path = DEST_PATH / "/".join(file_tree[3:-1])
    dest_path.mkdir(parents=True, exist_ok=True)
    filename = file_tree[-1]
    if int(filename[-7:-3]) > 1950:
        is_downloaded, message = uu.download_file(
            dest_path, filename, file,
        )
        print(message)