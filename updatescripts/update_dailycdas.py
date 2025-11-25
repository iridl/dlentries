#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path
import datetime
from dateutil.relativedelta import relativedelta
import urllib.request as urlr
import re
import tempfile


URL_THREDDS = "https://psl.noaa.gov/thredds/"
URL_DS = "Datasets/ncep.reanalysis/Dailies/"
URL_FILESERVER = f'{URL_THREDDS}fileServer/{URL_DS}'
URL_CATALOG = f'{URL_THREDDS}catalog/{URL_DS}'
DEST_PATH = Path("/Data/data6/ncep-ncar/daily/psl")
VARIABLES_PATH = {
    "csulf.ntat.gauss":     "other_gauss",
    "csusf.ntat.gauss":     "other_gauss",
    "dswrf.ntat.gauss":     "other_gauss",
    "pres.hcb.gauss":       "other_gauss",
    "pres.hct.gauss":       "other_gauss",
    "pres.lcb.gauss":       "other_gauss",
    "pres.lct.gauss":       "other_gauss",
    "pres.mcb.gauss":       "other_gauss",
    "pres.mct.gauss":       "other_gauss",
    "tcdc.eatm.gauss":      "other_gauss",
    "ulwrf.ntat.gauss":     "other_gauss",
    "uswrf.ntat.gauss":     "other_gauss",
    "air":                  "pressure",
    "hgt":                  "pressure",
    "omega":                "pressure",
    "rhum":                 "pressure",
    "shum":                 "pressure",
    "uwnd":                 "pressure",
    "vwnd":                 "pressure",
    "air.sig995":           "surface",
    "lftx.sfc":             "surface",
    "lftx4.sfc":            "surface",
    "omega.sig995":         "surface",
    "pottmp.sig995":        "surface",
    "pr_wtr.eatm":          "surface",
    "pres.sfc":             "surface",
    "rhum.sig995":          "surface",
    "slp":                  "surface",
    "uwnd.sig995":          "surface",
    "vwnd.sig995":          "surface",
    "air.2m.gauss":         "surface_gauss",
    "cfnlf.sfc.gauss":      "surface_gauss",
    "cfnsf.sfc.gauss":      "surface_gauss",
    "cprat.sfc.gauss":      "surface_gauss",
    "csdlf.sfc.gauss":      "surface_gauss",
    "csdsf.sfc.gauss":      "surface_gauss",
    "csusf.sfc.gauss":      "surface_gauss",
    "dlwrf.sfc.gauss":      "surface_gauss",
    "dswrf.sfc.gauss":      "surface_gauss",
    "gflux.sfc.gauss":      "surface_gauss",
    "dswrf.sfc.gauss":      "surface_gauss",
    "icec.sfc.gauss":       "surface_gauss",
    "lhtfl.sfc.gauss":      "surface_gauss",
    "nbdsf.sfc.gauss":      "surface_gauss",
    "nddsf.sfc.gauss":      "surface_gauss",
    "nlwrs.sfc.gauss":      "surface_gauss",
    "nswrs.sfc.gauss":      "surface_gauss",
    "pevpr.sfc.gauss":      "surface_gauss",
    "prate.sfc.gauss":      "surface_gauss",
    "pres.sfc.gauss":       "surface_gauss",
    "runof.sfc.gauss":      "surface_gauss",
    "sfcr.sfc.gauss":       "surface_gauss",
    "shtfl.sfc.gauss":      "surface_gauss",
    "shum.2m.gauss":        "surface_gauss",
    "skt.sfc.gauss":        "surface_gauss",
    "soilw.0-10cm.gauss":   "surface_gauss",
    "soilw.10-200cm.gauss": "surface_gauss",
    "tmax.2m.gauss":        "surface_gauss",
    "tmin.2m.gauss":        "surface_gauss",
    "tmp.0-10cm.gauss":     "surface_gauss",
    "tmp.10-200cm.gauss":   "surface_gauss",
    "tmp.300cm.gauss":      "surface_gauss",
    "uflx.sfc.gauss":       "surface_gauss",
    "ugwd.sfc.gauss":       "surface_gauss",
    "ulwrf.sfc.gauss":      "surface_gauss",
    "uswrf.sfc.gauss":      "surface_gauss",
    "uwnd.10m.gauss":       "surface_gauss",
    "vbdsf.sfc.gauss":      "surface_gauss",
    "vddsf.sfc.gauss":      "surface_gauss",
    "vflx.sfc.gauss":       "surface_gauss",
    "vgwd.sfc.gauss":       "surface_gauss",
    "vwnd.10m.gauss":       "surface_gauss",
    "weasd.sfc.gauss":      "surface_gauss",
    "air.tropp":            "tropopause",
    "pres.tropp":           "tropopause",
}
TODAY = datetime.date.today()
# In January, check also last year file
YEARS = [TODAY.year] if TODAY.month > 1 else [TODAY.year -1, TODAY.year]
for year in YEARS :
    for var in VARIABLES_PATH:
        file_name = f"{var}.{year}.nc"
        dest_path = DEST_PATH / VARIABLES_PATH[var]
        file_path = dest_path / file_name
        url_file = f"{URL_FILESERVER}{VARIABLES_PATH[var]}/{file_name}"
        if not file_path.is_file():
            # Case we don't have the new year file yet
            is_downloaded, message = uu.download_file(
                file_path.parent, file_path.name, url_file
            )
            print(message)
        else:
            last_modified = datetime.datetime.fromtimestamp(
                file_path.stat().st_mtime, tz=datetime.timezone.utc
            )
            with urlr.urlopen(
                f'{URL_CATALOG}{VARIABLES_PATH[var]}/catalog.html'
                f'?dataset={URL_DS}{VARIABLES_PATH[var]}/{file_name}'
            ) as catalog:
                if catalog.status != 200:
                    raise Exception(
                        f'Trying to get the catalog returned status {catalog.status}'
                    )
                url_text = catalog.read().decode()
            last_modified_remote = re.search(
                r'<b>modified</b>[\r\n]([^\r\n]+)', url_text
            ).group()
            last_modified_remote = datetime.datetime.fromisoformat(
                re.search(r'\d{4}\-\d{2}\-\d{2}T.*', last_modified_remote).group()
            )
            if last_modified_remote <= last_modified :
                print(f'{file_name} is up to date')
            else:
                with tempfile.TemporaryDirectory(dir=dest_path) as tmp:
                    is_downloaded, message = uu.download_file(
                        Path(tmp), file_name, url_file
                    )
                    print(message)
                    if is_downloaded:
                        # rename tmp to older file
                        (Path(tmp) / file_name).rename(file_path)
