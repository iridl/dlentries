#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import update_utilities as uu
import datetime


DEST_PATH = Path("/Data/data23/NMME/CanSIPS-IC-4.D/forecast")
URL_PATH = "https://collaboration.cmc.ec.gc.ca/cmc/CMOI/GRIB/NMME/1p0deg"
VARIABLES = [
    "HGT_ISBL_0200",
    "HGT_ISBL_0500",
    "PRATE_SFC_0",
    "PRMSL_MSL_0",
    "SSHG_SFC_0",
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

for var in VARIABLES:
    var_file = (
        f'{(uu.previous_month() - datetime.timedelta(days=1)).strftime("%Y%m%d")}00'
        f'_cansips_forecast_raw_nmme_latlon-1x1_{var}_'
        f'{datetime.datetime.today().strftime("%Y-%m")}_allmembers.grib2'
    )
    is_downloaded, message = uu.download_file(
        DEST_PATH, var_file, f'{URL_PATH}/{var_file}'
    )
    print(message)
        