#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import urllib.request as urlr
import update_utilities as uu


DEST_PATH = Path("/Data/data23/NMME/CanSIPS-IC-4.D/hindcast-20240624")
URL_PATH = "https://collaboration.cmc.ec.gc.ca/cmc/CMOI/GRIB/CanSIPS-IC-4-hindcast"
VARIABLES = [
    "HGT_ISBL_0200",
    "HGT_ISBL_0500",
    "PRATE_SFC_0",
    "PRMSL_MSL_0",
    "TMAX_TGL_2m",
    "TMIN_TGL_2m",
    "TMP_ISBL_0850",
    "TMP_TGL_2m",
    "UGRD_ISBL_0200",
    "UGRD_ISBL_0850",
    "VGRD_ISBL_0200",
    "VGRD_ISBL_0850",
    "WTMP_SFC_0",
]

for year in range(1990, 2021):
    dest_path = DEST_PATH / f'{year}'
    dest_path.mkdir(exist_ok=True)
    for var in VARIABLES:
        for month in range(1, 13):
            file = (
                f'cansips_hindcast_raw_nmme_latlon-1x1_'
                f'{var}_{year}-{str(month).zfill(2)}_allmembers.grib2'
            )
            is_downloaded, message = uu.download_file(
                dest_path, file, f'{URL_PATH}/{year}/{file}',
            )
            print(message)