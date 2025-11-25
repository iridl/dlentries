#!/usr/local/bin/condarun updatescripts2

import pandas as pd
import datetime
from dateutil.relativedelta import relativedelta
import update_utilities as uu
from pathlib import Path


URL_PATH = "https://noaa-cfs-pds.s3.amazonaws.com"
#template target path/file below
#cfs.20250706/00/monthly_grib_01/flxf.01.2025070600.202507.avrg.grib.00Z.grb2"
DEST_PATH = Path("/Data/data22/noaa/ncep/cfsv2/fcst")
TODAY = datetime.date.today()

#Will schedule early in the month to catch up past month in case we missed from the
#7-day rotating archive where operational files comes from
#Not going all the way up to TODAY to avoid both scripts trying to get same files at
#the same time
for date in pd.date_range(
    TODAY - datetime.timedelta(days=37), TODAY - datetime.timedelta(days=8)
):
    issue_date = date.strftime("%Y%m%d")
    for hr in ["00", "06", "12", "18"]:
        url_path = f'{URL_PATH}/cfs.{issue_date}/{hr}/monthly_grib_01'
        dest_path = (
            DEST_PATH / f'{date.year}' / date.strftime("%m") / date.strftime("%d") / hr
        )
        for vars in ["flxf", "ipvf", "ocnf", "ocnh", "pgbf"]:
            #From seemingly de 25th, targets an additional month
            #Will check from the 20th as I am not sure what the rule is
            leads = 11 if date.day >= 20 else 10
            #Targets issue date's month and up to leads-1 more months
            targets = [
                (date + relativedelta(months=m)).strftime("%Y%m")
                for m in range(leads)
            ]
            for target in targets:
                for hr2 in ["", ".00Z", ".06Z", ".12Z", ".18Z"]:
                    file_name = (
                        f'{vars}.01.{issue_date}{hr}.{target}.avrg.grib{hr2}.grb2'
                    )
                    is_downloaded, message = uu.download_file(
                        dest_path, file_name, f'{url_path}/{file_name}'
                    )
                    print(message)
