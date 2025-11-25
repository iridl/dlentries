#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import datetime


DEST_DIR = Path("/Data/data6/noaa/cpc/unified_prcp/global/v1p0/RT")
URL = "ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/RT"
TODAY = datetime.datetime.today()

for date in [(TODAY - datetime.timedelta(days=d)) for d in range(1,8)]:
    dest_dir_yr = DEST_DIR / f'{date.year}'
    dest_dir_yr.mkdir(mode=uu.DIR_MODE, parents=True, exist_ok=True)
    file_name = f'PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.{date.strftime("%Y%m%d")}.RT'
    is_downloaded, message = uu.download_file(
        dest_dir_yr,
        file_name,
        f'{URL}/{date.year}/{file_name}',
        expected_file_size=2073600,
    )
    print(message)
