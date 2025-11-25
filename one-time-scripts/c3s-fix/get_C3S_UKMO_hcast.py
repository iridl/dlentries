#!/usr/local/bin/condarun updatescripts

import cdsapi
import datetime
import sys
from pathlib import Path


#
# Copyright 2017-2021 European Centre for Medium-Range Weather Forecasts (ECMWF).
#  MODIFIED BY KYLE HALL  BUT THEY HAVENT ACCEPTED MY PULL REQUEST 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Authors:
#   Alessandro Amici - B-Open - https://bopen.eu
#   Aureliana Barghini - B-Open - https://bopen.eu
#   Leonardo Barcaroli - B-Open - https://bopen.eu
#


YEAR = sys.argv[1]
MONTH = sys.argv[2]


def get_ukmo_monthly_files(dest, year=None, month=None, filepattern=None, variables={}, overwrite=False, blurb=''):
	destination = Path(dest)
	assert destination.is_dir(), '{} does not exist as a directory'.format(destination.absolute())
	
	assert '{var}' in filepattern, 'spot for variable not found in filepattern'
	assert '{year}' in filepattern, 'spot for year not found in filepattern'
	assert '{month}' in filepattern, 'spot for month not found in filepattern'

	month = month if month is not None else datetime.datetime.today().strftime('%m')
	year = year if year is not None else datetime.datetime.today().strftime('%Y')

	full_destination_pattern = str( destination.absolute() / filepattern) 
	
	c = cdsapi.Client()
	for var in variables.keys():
		singlevar_destination_file = Path(eval("f'" + full_destination_pattern + "'"))
		failed1 = False
		if not singlevar_destination_file.is_file() or overwrite: 
			try:
				temp = c.retrieve(
					'seasonal-monthly-single-levels',
					{
					    'originating_centre':'ukmo',
					    'system':'600',
					    'variable':variables[var],
					    'product_type':'monthly_mean',
					    'year':year,
					    'month':month,
					    'leadtime_month':[
						    '1','2','3',
						    '4','5','6'
					    ],
					    'format':'grib',
					}
                                )
				temp.download(str(singlevar_destination_file))
			except:
				print("Something went wrong trying to download")


if __name__=="__main__":
	glosea6_destination = "/Data/data21/EC/Copernicus/CDS/C3S/UKMO/GloSea6-GC2/System600/hindcast/"
	target_variables = {
		'sst': 'sea_surface_temperature',
		't2m': '2m_temperature',
		'prcp': 'total_precipitation',
		'slp': 'mean_sea_level_pressure',
		'va': '10m_v_component_of_wind',
		'ua': '10m_u_component_of_wind'
	}
	blurb = 'C3S_UKMO_GloSea6_600_hcast_mon_mean'
	ukmo_filepattern = '{var}_{blurb}_{year}{month}.grb'

	get_ukmo_monthly_files(glosea6_destination, year=YEAR, month=MONTH, filepattern=ukmo_filepattern, variables=target_variables, blurb=blurb)

