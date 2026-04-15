#!/usr/local/bin/condarun updatescripts

import update_utilities as uu
from pathlib import Path
import datetime
import pandas as pd


URL_PATH = "https://portal.nccs.nasa.gov/datashare/gmao/geos-s2s-3/NRT/SubC"
DEST_PATH = Path("/Data/SubX/NASA/GEOS_V3/forecast")
TODAY = datetime.date.today()
# Issues 5-daily on a 365-day calendar can be formed by pd.date_range from March 2nd
# and 73 periods
TODAYS_YEAR_MARCH_2ND = TODAY.replace(day=2, month=3)
VALID_ISSUES = pd.date_range(
    start=TODAYS_YEAR_MARCH_2ND.replace(year=(TODAY.year - 1)),
    freq="5D", periods=73,
).union(pd.date_range(
    start=TODAYS_YEAR_MARCH_2ND,
    freq="5D", periods=73,
))
# Check back up to 60 days ago
ISSUES = [
    d
    for d in VALID_ISSUES
    if (
        (pd.Timestamp(TODAY) < (d + datetime.timedelta(days=60)))
        and (d <= pd.Timestamp(TODAY))
    )
]

for adate in ISSUES :
    adate_Ymd = adate.strftime("%Y%m%d")
    for var in [
        "frocean", "frseaice", "mrro", "mrso", "olr", "pr_sfc", "rzsm", "sic",
        "tas_2m", "ts_sfc", "ua_200", "ua_850", "va_200", "va_850", "zg_200",
        "zg_500",
    ] :
        members = (
            15
            # Last issue of month has 15 members
            if ((adate + datetime.timedelta(days=5)).month % 12) > adate.month
            else 5
        )
        for member in range(1, members + 1):
            file_name = f"{var}_GMAOGEOS_{adate_Ymd}_ens{member:02}.nc4"
            download_status = uu.download_file(
                DEST_PATH / adate_Ymd, file_name,
                f'{URL_PATH}/{adate_Ymd}/{file_name}',
            )
            print(download_status["message"])
            