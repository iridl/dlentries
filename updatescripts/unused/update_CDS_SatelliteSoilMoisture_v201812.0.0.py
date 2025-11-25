#!/usr/local/bin python2.7

import cdsapi
import datetime
import os
import sys
import zipfile
import os.path

#curdir = "/Data/data21/EC/Copernicus/CDS/SatelliteSoilMoisture/v201812.0.0"

os.chdir("/Data/data21/EC/Copernicus/CDS/SatelliteSoilMoisture/v201812.0.0")
print(os.getcwd())

cwd = os.getcwd()

c = cdsapi.Client()

#for yr in range (2020, 2020):
#	print (yr)
#	print ( str(yr) + str(mon).zfill(2) )


moncur = datetime.datetime.today().strftime('%m')
yrcur = datetime.datetime.today().strftime('%Y')
#yr = '2020'
#moncur = '01'
print (moncur)
print (yrcur)

for ict in range (-1, 1):
    montemp = int(moncur) + ict
    if montemp == 13:
	mon = "01"
	yr = yrcur + 1
    else:
	if montemp == 0:
		mon = "12"
		yr = yrcur - 1
	else:
		mon = str(montemp).zfill(2)
		print (mon)
		yr = yrcur


#   for yr in range (1993, 2017):
#       print (yr)
#       print ( str(yr) + str(mon).zfill(2) )

	yrs = str(yr)

	print (mon)
	print (yrs)

	dk1fil = "soil_moisture_saturation_v201812.0.0_" + str(yr) + str(mon).zfill(2) + "_dk1" + ".zip"
        print (dk1fil)

	if os.path.isfile(dk1fil):
		print("Already have " + dk1fil + " file. Do not download.")
	else:

		dk1 = c.retrieve(
			'satellite-soil-moisture',
			{
				'format': 'zip',
				'variable':'soil_moisture_saturation',
				'type_of_sensor': 'active',
				'time_aggregation': '10_day_average',
				'year':yrs,
				'month':mon,
				'day': '01',
				'version': 'v201812.0.0',
				'type_of_record': 'icdr',
			})

		dk1.download('soil_moisture_saturation_v201812.0.0_' + str(yr) + str(mon).zfill(2) + '_dk1' + '.zip')

		with zipfile.ZipFile(dk1fil,"r") as zip_ref:
			zip_ref.extractall("/Data/data21/EC/Copernicus/CDS/SatelliteSoilMoisture/v201812.0.0")


	dk2fil = "soil_moisture_saturation_v201812.0.0_" + str(yr) + str(mon).zfill(2) + "_dk2" + ".zip"
        print (dk2fil)

	if os.path.isfile(dk2fil):
		print("Already have " + dk2fil + " file. Do not download.")
	else:

		dk2 = c.retrieve(
			'satellite-soil-moisture',
			{
				'format': 'zip',
				'variable':'soil_moisture_saturation',
				'type_of_sensor': 'active',
				'time_aggregation': '10_day_average',
				'year':yrs,
				'month':mon,
				'day': '11',
				'version': 'v201812.0.0',
				'type_of_record': 'icdr',
			})

		dk2.download('soil_moisture_saturation_v201812.0.0_' + str(yr) + str(mon).zfill(2) + '_dk2' + '.zip')

		with zipfile.ZipFile(dk2fil,"r") as zip_ref:
			zip_ref.extractall("/Data/data21/EC/Copernicus/CDS/SatelliteSoilMoisture/v201812.0.0")

	dk3fil = "soil_moisture_saturation_v201812.0.0_" + str(yr) + str(mon).zfill(2) + "_dk3" + ".zip"
        print (dk3fil)

	if os.path.isfile(dk3fil):
		print("Already have " + dk3fil + " file. Do not download.")
	else:
	
		dk3 = c.retrieve(
			'satellite-soil-moisture',
			{
				'format': 'zip',
				'variable':'soil_moisture_saturation',
				'type_of_sensor': 'active',
				'time_aggregation': '10_day_average',
				'year':yrs,
				'month':mon,
				'day': '21',
				'version': 'v201812.0.0',
				'type_of_record': 'icdr',
			})

		dk3.download('soil_moisture_saturation_v201812.0.0_' + str(yr) + str(mon).zfill(2) + '_dk3' + '.zip')

		with zipfile.ZipFile(dk3fil,"r") as zip_ref:
			zip_ref.extractall("/Data/data21/EC/Copernicus/CDS/SatelliteSoilMoisture/v201812.0.0")


