#!/usr/local/bin/condarun updatescripts2

# Inspired from
# https://cds.climate.copernicus.eu/datasets/satellite-soil-moisture?tab=download

import cdsapi
import sys
from collections import namedtuple
from pathlib import Path
import update_utilities as uu
import tempfile
import datetime
import pandas as pd

VAR = sys.argv[1] # ssm, vssm
TIME_RES = sys.argv[2] # day, 10_day, month

Parameters = namedtuple("Parameters", [
    "variable", "sensor", "short_name", "sensor_name",
])
PARAMETERS = {
    "ssm" : Parameters(
        "surface_soil_moisture",
        "active",
        "SSMS",
        "ACTIVE",
    ),
    "vssm" : Parameters(
        "volumetric_surface_soil_moisture",
        "combined_passive_and_active",
        "SSMV",
        "COMBINED",
    )
}

DESTINATION = Path("/Data/data21/EC/Copernicus/CDS/C3S/satellite-soil-moisture/v202212")
DESTINATION = DESTINATION / VAR / TIME_RES / "icdr"

#Every try, we'll try current month and full past month
PREVIOUS_MONTH = uu.previous_month(iter=1)
DAYS = pd.date_range(PREVIOUS_MONTH, datetime.datetime.today())
TIME_NAME = "DAILY"
if TIME_RES != "day" :
    DAYS = DAYS[(DAYS.day == 1) | (DAYS.day == 11) | (DAYS.day == 21)]
    TIME_NAME = "DEKADAL"
    if TIME_RES == "month":
        DAYS = DAYS[DAYS.day == 1]
        TIME_NAME = "MONTHLY"
# Remove days already in-house
DAYS = DAYS[[
    not (
        DESTINATION /
        f'{day.year}' /
        (
            f'C3S-SOILMOISTURE-L3S-'
            f'{PARAMETERS[VAR].short_name}-{PARAMETERS[VAR].sensor_name}-'
            f'{TIME_NAME}-{day.strftime("%Y%m%d")}'
            f'000000-ICDR-v202212.0.0.nc'
        )
    ).is_file() for day in DAYS
]]

for day in DAYS :
    (DESTINATION / f'{day.year}').mkdir(
        mode=uu.DIR_MODE, parents=True, exist_ok=True
    )
    dataset = "satellite-soil-moisture"
    client = cdsapi.Client()
    request = {
        "variable": [PARAMETERS[VAR].variable],
        "type_of_sensor": [PARAMETERS[VAR].sensor],
        "time_aggregation": [f'{TIME_RES}_average'],
        "year": [f'{day.year}'],
        "month": [f'{day.month:02}'],
        "day": [f'{day.day:02}'],
        "type_of_record": ["icdr"],
        "version": ["v202212"],
    }
    try:
        with tempfile.TemporaryDirectory(dir=DESTINATION) as td:
            target = client.retrieve(dataset, request).download(f'{td}/afile.zip')
            unpacked_dir, message = uu.unpack(
                Path(target),
                keep_packed_file=False,
            )
            print(message)
            unpacked_files = list(unpacked_dir.glob('*.nc'))
            assert len(unpacked_files) == 1
            unpacked_file = unpacked_files[0]
            message = uu.add_to_dataset(
                unpacked_file,
                new_path=(DESTINATION / f'{day.year}' / unpacked_file.name),
            )
            print(message)
    except Exception as e:
        print(f'download or zip extraction failed with exception: {e}')
