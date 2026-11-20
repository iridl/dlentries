#!/usr/local/bin/condarun updatescripts

# ======================================================================
# WARNING: NOT ALL ENSEMBLE MEMBERS HAVE ALL LEADS
# ----------------------------------------------------------------------
# This script requests leads 1..LEADS (9) for EVERY ensemble member, but
# the GEOS-S2S-3 NMME forecasts do not provide 9 leads for all members:
#
#   * All members go out only 2 months (3 for the early issues).
#   * After 3 months of integration, a clustering step selects ~10 of the
#     ~45 members of the month (the "winners") to run out to 9 months.
#   * The winners CHANGE from month to month: which member of which start
#     date runs to 9 months differs every month.
#   * The ensemble at any lead is the mean of ALL members available at
#     that lead, so the number of members decreases with lead time.
#
# Consequences for this script:
#   * Missing files for leads >= 3 (or 4) are EXPECTED for most members.
#     They are not necessarily download errors.
#   * Only leads 1-2 (or 1-3) can be assumed for every member.
#
# NUMBER OF MEMBERS PER ISSUE:
#   Members are concentrated at the END of each month. Early issues have
#   5 members each, while the last issue of the month has 15 members
#   (see the `member` var -> n_members func  below).
# ======================================================================

import update_utilities as uu
from pathlib import Path
import datetime
import pandas as pd

URL_PATH = "https://portal.nccs.nasa.gov/datashare/gmao/geos-s2s-3/NRT/NMME/monthly"
DEST_PATH = Path("/Data/data23/NMME/NASA_GEOS-S2S-3/Forecast")
TODAY = datetime.date.today()
# Issues 5-daily on a 365-day calendar from Oct 3th
TODAYS_YEAR_OCT_3TH = TODAY.replace(day=3, month=10)
VALID_ISSUES = pd.date_range(
    start=TODAYS_YEAR_OCT_3TH.replace(year=(TODAY.year - 1)),
    freq="5D", periods=73,
).union(pd.date_range(
    start=TODAYS_YEAR_OCT_3TH,
    freq="5D", periods=73,
))

MONTH_DIR = TODAY.strftime("%b%Y").lower()
PREV_MONTH_END = TODAY.replace(day=1) - datetime.timedelta(days=1)
LEADS = 9
# Leads that every member is expected to have (3 for the earliest issues,
# so 2 is the safe minimum). Leads above this are optional ("winners" only).
REQUIRED_LEADS = 2
VARS = [
    "at", "evpintr", "evpsoil", "evptrans", "olr", "precip", "slp", "sst", "t200", "t2mmax",
    "t2mmin", "t850", "taux", "tauy", "u200", "u850", "v200", "v850", "wet3", "z200", "z500"
]
ISSUES = [
    d
    for d in VALID_ISSUES
    if (d.year, d.month) == (PREV_MONTH_END.year, PREV_MONTH_END.month)
]


def n_members(adate):
    # Last issue of month has 15 members
    return 15 if (adate + datetime.timedelta(days=5)).month != adate.month else 5


# ----------------------------------------------------------------------
# DOWNLOAD
# ----------------------------------------------------------------------
for adate in ISSUES:
    adate_Ymd = adate.strftime("%Y%m%d")
    for var in VARS:
        #20261003.at.ens1.lead1.nc4
        for member in range(1, n_members(adate) + 1):
            for lead in range(1, LEADS + 1):
                file_name = f"{adate_Ymd}.{var}.ens{member}.lead{lead}.nc4"
                download_status = uu.download_file(
                    DEST_PATH / MONTH_DIR, file_name,
                    f'{URL_PATH}/{MONTH_DIR}/{file_name}',
                )
                local_file = DEST_PATH / MONTH_DIR / file_name
                file_present = local_file.exists() and local_file.stat().st_size > 0
                if lead > REQUIRED_LEADS and not file_present:
                    # Long leads exist only for the "winner" members
                    print(f"{file_name}: not available (expected, lead > {REQUIRED_LEADS})")
                else:
                    print(download_status["message"])