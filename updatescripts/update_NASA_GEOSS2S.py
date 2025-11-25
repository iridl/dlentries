#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import datetime
from dateutil.relativedelta import relativedelta


TODAY = datetime.date.today()
DEST_PATH = Path("/Data/data23/NMME/NASA_GEOSS2S.D/Forecast.D")
URL_PATH = (
    f"https://gmao.gsfc.nasa.gov/gmaoftp/gmaofcst/seasonal/GEOSS2S-2_1/NMME/forecast"
    f"/monthly/{TODAY.year}/{TODAY.strftime("%b").lower()}"
)
VARS = [
    "evap", "h200", "h250", "h500", "mrsov", "precip", "runoff", "ssh", "sst",
    "t2mmax", "t2mmin", "taux", "tauy", "tref",
]


def file_name_and_path(adate, member, var):
    # Each issue date has 10 members that are actually specific start dates of the
    # previous month. This table lists these mmdd dates as they are expected in file
    # names. Taken from the Catalog that relies on them as well
    # Rows are the 12 months of issues from Jan to Dec
    members = [
	    ["1212", "1217", "1222", "1227", "1227", "1227", "1227", "1227", "1227", "1227"],
	    ["0116", "0121", "0126", "0131", "0131", "0131", "0131", "0131", "0131", "0131"],
	    ["0210", "0215", "0220", "0225", "0225", "0225", "0225", "0225", "0225", "0225"],
	    ["0312", "0317", "0322", "0327", "0327", "0327", "0327", "0327", "0327", "0327"],
	    ["0411", "0416", "0421", "0426", "0426", "0426", "0426", "0426", "0426", "0426"],
	    ["0516", "0521", "0526", "0531", "0531", "0531", "0531", "0531", "0531", "0531"],
	    ["0615", "0620", "0625", "0630", "0630", "0630", "0630", "0630", "0630", "0630"],
	    ["0715", "0720", "0725", "0730", "0730", "0730", "0730", "0730", "0730", "0730"],
	    ["0814", "0819", "0824", "0829", "0829", "0829", "0829", "0829", "0829", "0829"],
	    ["0913", "0918", "0923", "0928", "0928", "0928", "0928", "0928", "0928", "0928"],
	    ["1013", "1018", "1023", "1028", "1028", "1028", "1028", "1028", "1028", "1028"],
	    ["1112", "1117", "1122", "1127", "1127", "1127", "1127", "1127", "1127", "1127"],
    ]
    path = f"{adate.strftime("%b")}.D"
    file_name = (
        f"{(TODAY + relativedelta(months=-1)).year}{members[adate.month-1][member]}"
        f"_1x1_{var}_ens{(member+1):02}.nc"
    )
    return (path, file_name)


for mem in range(10):
    for var in VARS:
        path, file_name = file_name_and_path(TODAY, mem, var)
        is_downloaded, message = uu.download_file(
            DEST_PATH / path, file_name, f"{URL_PATH}/{file_name}",
        )
        print(message)
with open(DEST_PATH / "endmonth.txt", mode="r+") as f:
    lines = f.readlines()
    current_last_month = lines[1][0:3]
    current_last_year = int(lines[1][4:8])
    found_last_available_S = False
    last_date = TODAY + relativedelta(months=1)
    while (
        (not found_last_available_S) & (relativedelta(TODAY, last_date).months < 4)
    ):
        last_date = last_date + relativedelta(months=-1)
        last_month = last_date.strftime("%b")
        last_year = last_date.year
        have_all_files = True
        for mem in range(10):
            for var in VARS:
                path, file_name = file_name_and_path(last_date, mem, var)
                have_all_files = (
                    have_all_files & (DEST_PATH / path / file_name).is_file()
                )
        found_last_available_S = have_all_files
    if found_last_available_S:
        if ((last_month == current_last_month) & (last_year == current_last_year)):
            print("current end of month is correct")
        else:
            print(f"updating end of month to {last_month} {last_year}")
            f.seek(0)
            f.truncate()
            f.write(f"{lines[0]}{last_month} {last_year}\n{lines[2]}")
    else:
        print("Could not find a complete set in last 4 months")
