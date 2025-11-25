#!/usr/local/bin/condarun updatescripts2

import update_utilities as uu
from pathlib import Path


URL_PATH = "https://psl.noaa.gov/thredds/fileServer/Datasets/ncep.reanalysis/Dailies/"
DEST_PATH = Path("/Data/data6/ncep-ncar/daily")
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
    "hgt.sfc":              "surface",
    "land":                 "surface",
    "lftc.sfc":             "surface",
    "lftx4.sfc":            "surface",
    "omega.sig995":         "surface",
    "pottmp.sig995":        "surface",
    "pr_wtr.eatm":          "surface",
    "pres.sfc":             "surface",
    "rhum.sig995":          "surface",
    "slp":                  "surface",
    "topo.sfc":             "surface",
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
    "hgt.sfc.gauss":        "surface_gauss",
    "icec.sfc.gauss":       "surface_gauss",
    "land.sfc.gauss":       "surface_gauss",
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
    "topo.sfc.gauss":       "surface_gauss",
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
for var in VARIABLES_PATH:
    if var in [
        "hgt.sfc", "land", "topo.sfc",
        "hgt.sfc.gauss", "land.sfc.gauss", "topo.sfc.gauss",
    ]:
        years_range = range(1)
    else:
        years_range = range(1948, 2025)
    for year in years_range:
        year = "" if year == 0 else f".{year}"
        file_name = f"{var}{year}.nc"
        is_downloaded, message = uu.download_file(
            (DEST_PATH / VARIABLES_PATH[var]), file_name,
            f"{URL_PATH}{VARIABLES_PATH[var]}/{file_name}",
        )
        print(message)
