#!/usr/local/bin/condarun updatescripts2

# Inspired from
# https://cds.climate.copernicus.eu/datasets/satellite-soil-moisture?tab=download

import cdsapi
import sys
from collections import namedtuple
from pathlib import Path
import tempfile
import zipfile


VAR = sys.argv[1] # ssm, vssm
TIME_RES = sys.argv[2] # day, 10_day, month
RECORD = sys.argv[3] # cdr, icdr
LAST_YEAR = 2022 if RECORD == "cdr" else 2024 

Parameters = namedtuple("Parameters", [
    "variable", "sensor", "year_start", "year_end",
])
PARAMETERS = {
    "ssm" : Parameters(
        "surface_soil_moisture",
        "active",
        1991 if RECORD == "cdr" else 2023,
        LAST_YEAR,
    ),
    "vssm" : Parameters(
        "volumetric_surface_soil_moisture",
        "combined_passive_and_active",
        1978 if RECORD == "cdr" else 2023,
        LAST_YEAR,
    ),
}
# Array of days is 1 or 1, 11, 21, or 1 to 31 every 1 respectively
if TIME_RES == "month" :
    LAST_DAY = 1
    TIME_STEP = 1
elif TIME_RES == "10_day" :
    LAST_DAY = 21
    TIME_STEP = 10
else: # TIME_RES == "day"
    LAST_DAY = 31
    TIME_STEP = 1

DESTINATION = Path("/Data/data21/EC/Copernicus/CDS/C3S/satellite-soil-moisture/v202212")
DESTINATION = DESTINATION / VAR/ TIME_RES / RECORD
DESTINATION.mkdir(mode=0o775, parents=True, exist_ok=True)

dataset = "satellite-soil-moisture"
client = cdsapi.Client()
# cdsapi donwloads a zip file with all files (timestep-wise) in request
# to avoid directories with large number of files (expecially for daily data)
# let's loop on years.
for year in range(PARAMETERS[VAR].year_start, PARAMETERS[VAR].year_end + 1) :
    request = {
    	"variable": [PARAMETERS[VAR].variable],
    	"type_of_sensor": [PARAMETERS[VAR].sensor],
    	"time_aggregation": [f'{TIME_RES}_average'],
    	"year": [str(year)],
    	"month": [
        	"01", "02", "03",
        	"04", "05", "06",
        	"07", "08", "09",
        	"10", "11", "12"
    	],
    	"day": [f'{day:02}' for day in range(1, LAST_DAY+1, TIME_STEP)],
    	"type_of_record": [RECORD],
    	"version": ["v202212"],
	}
    dest_yr = DESTINATION / f'{year}'
    try:
        with tempfile.NamedTemporaryFile(dir=DESTINATION) as tf:
            client.retrieve(dataset, request).download(tf.name)
            Path(tf.name).chmod(0o664)
            dest_yr.with_suffix('.zip').hardlink_to(tf.name)
        with zipfile.ZipFile(dest_yr.with_suffix('.zip'), 'r') as zip_ref:
            with tempfile.TemporaryDirectory(dir=DESTINATION) as td:
                zip_ref.extractall(td)
                Path(td).chmod(0o775)
                for dirpath, dirnames, filenames in Path(td).walk():
                    for d in dirnames:
                        (dirpath / d).chmod(0o775)
                    for f in filenames:
                        (dirpath / f).chmod(0o664)
                Path(td).rename(dest_yr)
        print(
            f'data downloaded unzipped successfully in {dest_yr}'
        )
        dest_yr.with_suffix('.zip').unlink()
    except Exception as e:
        print(f'download or zip extraction failed with exception: {e}')
        
              
     
