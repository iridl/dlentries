#!/usr/local/bin/condarun updatescripts

import earthaccess
from pathlib import Path
import datetime as dt
import update_utilities as uu
import tempfile


DEST_PATH = "/Data/data22/usgs/lpdaac/VIIRS/VNP13C2.002/nc"
GROUP = "/HDFEOS/GRIDS/VIIRS_Grid_monthly_VI_CMG/Data Fields"

LAST_MONTH_PLUS_1 = (
    dt.timedelta(days=31)
    + dt.datetime.strptime(
        (sorted(Path(DEST_PATH).glob("*.h5"))[-1]).stem.split(".")[1][1:], "%Y%j"
    )
).strftime("%Y-%m")

AUTH = earthaccess.login()

RESULTS = earthaccess.search_data(
    short_name = "VNP13C2",
    version = "002",
    temporal = (f'{LAST_MONTH_PLUS_1}-01', dt.date.today().strftime("%Y-%m-%d")),
)

if len(RESULTS) != 0 :
    with tempfile.TemporaryDirectory(dir=DEST_PATH) as temp_dir:
        download_files = earthaccess.download(
            RESULTS,
            local_path=temp_dir,
        )
        for file in download_files :
            print(f'Processing {file}')
            uu.open_and_split_to(
                Path(file).parent,
                Path(file).name,
                from_format="HDF-EOS",
                group=GROUP,
                to_suffix=".nc"
            )
            print(f'Moving split files to {Path(file).stem}')
            (Path(DEST_PATH) / Path(file).stem).mkdir(
                mode=uu.DIR_MODE, parents=True, exist_ok=True
            )
            for split_file in Path(file).parent.glob(f'{Path(file).stem}_*.nc'):
                uu.add_to_dataset(
                    split_file,
                    new_path=(Path(DEST_PATH) / Path(file).stem / split_file.name),
                )
            print(f'Moving downloaded file to {DEST_PATH}')
            uu.add_to_dataset(
                Path(file), new_path=(Path(DEST_PATH) / Path(file).name)
            )
