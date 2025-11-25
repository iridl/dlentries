#!/usr/local/bin python2.7

import cdsapi
import datetime
import os
import sys

curdir = "/Data/data21/EC/Copernicus/CDS/C3S/DWD/GCFS2p0/forecast"

os.chdir("/Data/data21/EC/Copernicus/CDS/C3S/DWD/GCFS2p0/forecast")
print(os.getcwd())

cwd = os.getcwd()

#if cwd != curdir:
#	sys.exit("Could not change directory -- quitting")

c = cdsapi.Client()

mon = datetime.datetime.today().strftime('%m')
yr = datetime.datetime.today().strftime('%Y')
#yr = 2018
#mon = 12
print (mon)
print (yr)

ufile = 'u_C3S_dwd_fcast_mon_mean_' + str(yr) + str(mon) +'.grb'
ufilepath = '/Data/data21/EC/Copernicus/CDS/C3S/DWD/GCFS2p0/forecast/' + str(ufile)
print(ufilepath)

if os.path.exists(ufilepath):
	sys.exit("U-file, last file downloaded, already exists. Quitting download script.")
else:

	sst = c.retrieve(
	    'seasonal-monthly-single-levels',
	    {
	        'originating_centre':'dwd',
		'system':'2',
	        'variable':'sea_surface_temperature',
	        'product_type':'monthly_mean',
#       	'year':'2018',
#       	'month':'12',
	        'year':yr,
	        'month':mon,
	        'leadtime_month':[
	            '1','2','3',
	            '4','5','6'
	        ],
	        'format':'grib'
	    })

	sst.download('sst_C3S_dwd_fcast_mon_mean_' + str(yr) + str(mon) +'.grb')

	t2m = c.retrieve(
	    'seasonal-monthly-single-levels',
	    {
	        'originating_centre':'dwd',
		'system':'2',
	        'variable':'2m_temperature',
	        'product_type':'monthly_mean',
#       	'year':'2018',
#       	'month':'12',
	        'year':yr,
	        'month':mon,
	        'leadtime_month':[
	            '1','2','3',
	            '4','5','6'
	        ],
	        'format':'grib'
	    })

	t2m.download('t2m_C3S_dwd_fcast_mon_mean_' + str(yr) + str(mon) +'.grb')

	prcp = c.retrieve(
	    'seasonal-monthly-single-levels',
	    {
	        'originating_centre':'dwd',
		'system':'2',
	        'variable':'total_precipitation',
	        'product_type':'monthly_mean',
#       	'year':'2018',
#       	'month':'12',
	        'year':yr,
	        'month':mon,
	        'leadtime_month':[
	            '1','2','3',
	            '4','5','6'
	        ],
	        'format':'grib'
	    })

#	prcp.download('prcp_C3S_dwd_fcast_mon_mean_201810.grb')
	prcp.download('prcp_C3S_dwd_fcast_mon_mean_' + str(yr) + str(mon) +'.grb')

	z = c.retrieve(
	    'seasonal-monthly-pressure-levels',
	    {
	        'originating_centre':'dwd',
		'system':'2',
	        'variable':'geopotential',
	        'product_type':'monthly_mean',
#       	'year':'2018',
#       	'month':'12',
	        'year':yr,
	        'month':mon,
	        'pressure_level':[
	            '925','850','700',
	            '500','400','300',
	            '200','100','50',
	            '30','10'
	        ],
	        'leadtime_month':[
	            '1','2','3',
	            '4','5','6'
	        ],
	        'format':'grib'
#       	'format':'netcdf'
	    })

#	r.download('z_C3S_dwd_fcast_mon_mean_201810.grb')
	z.download('z_C3S_dwd_fcast_mon_mean_' + str(yr) + str(mon) +'.grb')

	v = c.retrieve(
	    'seasonal-monthly-pressure-levels',
	    {
	        'originating_centre':'dwd',
		'system':'2',
	        'variable':'v_component_of_wind',
	        'product_type':'monthly_mean',
#       	'year':'2018',
#       	'month':'12',
	        'year':yr,
	        'month':mon,
	        'pressure_level':[
	            '925','850','700',
	            '500','400','300',
	            '200','100','50',
	            '30','10'
	        ],
	        'leadtime_month':[
	            '1','2','3',
	            '4','5','6'
	        ],
	        'format':'grib'
#       	'format':'netcdf'
	    })

	v.download('v_C3S_dwd_fcast_mon_mean_' + str(yr) + str(mon) +'.grb')

	u = c.retrieve(
	    'seasonal-monthly-pressure-levels',
	    {
	        'originating_centre':'dwd',
		'system':'2',
	        'variable':'u_component_of_wind',
	        'product_type':'monthly_mean',
#       	'year':'2018',
#       	'month':'12',
	        'year':yr,
	        'month':mon,
	        'pressure_level':[
	            '925','850','700',
	            '500','400','300',
	            '200','100','50',
	            '30','10'
	        ],
	        'leadtime_month':[
	            '1','2','3',
	            '4','5','6'
	        ],
	        'format':'grib'
#       	'format':'netcdf'
	    })

	u.download('u_C3S_dwd_fcast_mon_mean_' + str(yr) + str(mon) +'.grb')


