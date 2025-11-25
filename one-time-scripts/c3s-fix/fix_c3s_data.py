import xarray as xr 
from pathlib import Path 
import datetime as dt 
import numpy as np
import cfgrib_small as cfgrib
from cfgrib_small import xarray_to_grib 
import sys , shutil
import pandas as pd 

# already done ukmo_glosea6_system600_fcst = Path('/mnt/moncephfs/ingriddata/data21/EC/Copernicus/CDS/C3S/UKMO/GloSea6-GC2/System600/forecast/')
ukmo_glosea5_system15_fcst = Path('/mnt/moncephfs/ingriddata/data21/EC/Copernicus/CDS/C3S/UKMO/GloSea5-GC2/System15/forecast/')
ukmo_glosea5_system14_fcst = Path('/mnt/moncephfs/ingriddata/data21/EC/Copernicus/CDS/C3S/UKMO/GloSea5-GC2/System14/forecast/')
jma_cps2_fcst = Path('/mnt/moncephfs/ingriddata/data21/EC/Copernicus/CDS/C3S/JMA/System2/Forecasts/') 

def fix_files(dir, max_members): 
	existing_files = [file for file in dir.glob('*.grb')]
	files_to_be_changed = [file for file in existing_files if 'old_' not in file.name and not (dir / ('old_' + file.name)).is_file() and 'new_' not in file.name and not (dir/('new_'+file.name)).is_file()]
	print('{} FOUND {} FILES TO REFORMAT'.format(dt.datetime.now(), len(files_to_be_changed)))
	for file in files_to_be_changed:
		fix_one_file(file, max_members=max_members)

	
def fix_one_file(fn, max_members=62, member_dim='number', lead_dim='step', init_dim='time', year=2021, month=9 ):
	print('{} FIXING {}'.format(dt.datetime.now(), fn))
	year, month = int(fn.name[-10:-6]), int(fn.name[-6:-4])
	file_init_timestamp = pd.Timestamp(year=year, month=month, day=1)
	#print(file_init_timestamp)
	old_fn = Path(fn.parents[0] / ('old_' + fn.name) )
	#fn.rename(old_fn)
	new_fn = Path(fn.parents[0] / ('new_' + fn.name) )
	if old_fn.is_file():
		old_fn.unlink()
	if new_fn.is_file():
		new_fn.unlink()

	shutil.copy(str(fn), str(old_fn))
	ds = xr.open_dataset(str(fn.absolute()), engine='cfgrib') 
	var = [i for i in ds.data_vars][0]
	da = getattr(ds, var) 
	member_dim_size = len(da.coords[member_dim].values) 
	 
	to_be_stacked = [] 
	for i in range(member_dim_size):
		seldict = {member_dim:i}
		temp_da = da.isel(**seldict).dropna(init_dim, how='all').dropna(lead_dim, how='all') 
		temp_da.coords[lead_dim] = [j+0.5 for j in range(6)]
		temp_da.coords[init_dim] = [file_init_timestamp]
		to_be_stacked.append(temp_da)
	new_da = xr.concat(to_be_stacked, member_dim)
	if member_dim_size < max_members:
		pad_dct = {member_dim: (0, max_members - member_dim_size) }
		new_da = new_da.pad(**pad_dct, constant_value=np.nan) 
	#print(new_da)
	new_da = xr.Dataset({new_da.name:new_da}, coords=new_da.coords)
	xarray_to_grib.to_grib(new_da, str(new_fn.absolute()))

if __name__=="__main__":
	#print('{} FIXING GLOSEA5 SYSTEM15'.format(dt.datetime.now()))
	#fix_files(ukmo_glosea5_system15_fcst, 62)
	#print('{} FIXING GLOSEA5 SYSTEM14'.format(dt.datetime.now()))
	#fix_files(ukmo_glosea5_system14_fcst, 62)
	print('{} FIXING JMA CPS2'.format(dt.datetime.now()))
	fix_files(jma_cps2_fcst, 91)


