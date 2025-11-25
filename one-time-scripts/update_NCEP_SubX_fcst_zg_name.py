#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import pandas as pd
import datetime
import xarray as xr
import tempfile


TODAY = datetime.datetime.today()
DEST_DIR = Path("/Data/SubX/NCEP/CFSv2/forecast")
ALL_DATES = pd.date_range("2024-05-01", TODAY)
VARS = ["zg_200", "zg_500"]

for adate in ALL_DATES :
    for var in VARS :
        for member in range(1, 5) :
            for anhour in range(0, 24, 6) :
                file_stem = (
                    f'{var}_CFS_{adate.strftime("%d%b%Y").lower()}'
                    f'_{anhour:02}z_d00_d44_m{member:02}'
                )
                #we need to post-process file with new file name
                #so need to test on new file name to know if we already have
                #uu.donwnload_file tests whether we have the file to be downloaded
                #we remove that file if post-processing was successful
                filet = f'{file_stem}_XYT.nc'
                dest_path = (
                    DEST_DIR /
                    f'{var}_CFS' /
                    adate.strftime("%Y") /
                    adate.strftime("%m")
                )
                if (dest_path / filet).is_file() :
                    try:
                        with tempfile.NamedTemporaryFile(dir=dest_path) as f:
                            datat = xr.open_dataset(dest_path / filet)
                            if var in datat.variables:
                                datat = datat.rename({var: "zg"})
                                message = "renamed to zg"
                            elif "zg" in datat.variables:
                                message = "already named zg"
                            else:
                                message = f'neither {var} nor zg in file'
                                raise ValueError(message)
                            print(message)
                            datat.to_netcdf(f.name)
                            (dest_path / filet).rename(dest_path / f'bad_zg_{filet}')
                            message = uu.add_to_dataset(
                                Path(f.name), new_path=(dest_path / filet)
                            )
                            (dest_path / f'bad_zg_{filet}').unlink()
                            print(message)
                        print(f'successful variable renaming of {filet}')
                    except Exception as e:
                        print(f'variable renaming of {filet} raised {e}')
