#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
import tempfile
import zipfile
from pathlib import Path
import sys

REGION = sys.argv[1] # eaf, waf; saf

#Paths in dest as keys and in URL as values
PATHS = {"eaf" : "east", "waf" : "west", "saf" : "southern"}

#For each REGION, keys are part of file name while values are in dest and URL path
CROPS = {
    "eaf" : {
        "ee" : "easte",
        "et" : "eastt",
        "ek" : "eastk",
        "el" : "eastl",
        "e1" : "east1",
        "e2" : "east2",
    },
    "waf" : {
        "wa" : "west",
        "w1" : "west1",
    },
    "saf" : {
        "sa" : "southern",
    },
}

URL_PATH = f'https://edcftp.cr.usgs.gov/project/fews/africa/{PATHS[REGION]}/dekadal/wrsi-chirps-etos/'
DEST_PATH = Path(f'/Data/data6/usgs/eros/fews/dekadal/wrsi-chirps-etos/{REGION}/')

for crop in CROPS[REGION]:
    crop_path = CROPS[REGION][crop]
    for file_y in range(1, 25):
        url_path = f'{URL_PATH}/{crop_path}'
        #URL has an extra historical path in some cases
        #but I am not reproducing that dummy structure in dest
        #because it would add unncessary complexity to Catalog
        to_append = "historical" if (
            (crop_path == "west") and (file_y < 23)
        ) else ""
        url_path = f'{url_path}/{to_append}'
        dest_path = DEST_PATH / crop_path
        dest_path.mkdir(mode=0o775, parents=True, exist_ok=True)
        for file_dkd in range(1, 37):
            #We know there are not files for all dekads
            #and that it depends on crop
            #but I figure I will implemente that in the update script
            #and be a bit rude for the one-time script
            file_stem = f'w20{file_y:02}{file_dkd:02}{crop}'
            print(file_stem)
            if (dest_path / file_stem).is_dir():
                is_downloaded = False
                print(f'Already got {file_stem}')
            else:
                is_downloaded, message = uu.download_file(
                    dest_path,
                    f'{file_stem}.zip',
                    f'{url_path}/{file_stem}.zip',
                )
                print(message)
                if is_downloaded:
                    try:
                        dest_dir = dest_path / file_stem
                        with zipfile.ZipFile(
                            dest_dir.with_suffix('.zip'), 'r',
                        ) as zip_ref:
                            with tempfile.TemporaryDirectory(dir=dest_path) as td:
                                zip_ref.extractall(td)
                                Path(td).chmod(0o775)
                                for dirpath, dirnames, filenames in Path(td).walk():
                                    for d in dirnames:
                                        (dirpath / d).chmod(0o775)
                                    for f in filenames:
                                        (dirpath / f).chmod(0o664)
                                Path(td).rename(dest_dir)
                        print(f'{file_stem} unzipped successfully')
                        dest_dir.with_suffix('.zip').unlink()
                    except Exception as e:
                        print(f'zip extraction failed with exception: {e}')
            