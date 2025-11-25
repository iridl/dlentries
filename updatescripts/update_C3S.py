#!/usr/local/bin/condarun updatescripts2

import argparse
import cdsapi
import datetime
import os
import calendar

topdir = '/Data/data21/EC/Copernicus/CDS/C3S'

case = {
    "fcast": "forecast",
    "hcast": "hindcast"
}

vars = {
    'sst': 'sea_surface_temperature',
    't2m': '2m_temperature',
    'prcp': 'total_precipitation',
    'z': 'geopotential',
    'v': 'v_component_of_wind',
    'u': 'u_component_of_wind',
    "mslp":'mean_sea_level_pressure',
}

common_args = {
    'product_type': 'monthly_mean',
    'leadtime_month': ['1', '2', '3', '4', '5', '6'],
    'format': 'grib',
}

pressure_levels = [
    '925','850','700',
    '500','400','300',
    '200','100','50',
    '30','10'
]

models = {
    'SEAS51': {
        'dir': 'ECMWF/SEAS51',
        'slug': 'C3S_ecmwf',
        'start_year': 1981,
        'end_year': 2023,
        'args': {
            'originating_centre': 'ecmwf',
            'system': '51',
        },
    },
    'METEOFRANCE': {
        'dir': 'Meteo_France/System9',
        'slug': 'C3S_MeteoFrance',
        'start_year': 1993,
        'end_year': 2024,
        'args': {
	    'originating_centre':'meteo_france',
	    'system':'9',
        },
    },
    'SPSv3p5': {
        'dir': 'CMCC/SPSv3p5',
        'slug': 'C3S_cmcc_SPSv3p5',
        'start_year': 1993,
        'end_year': 2023,
        'args': {
            'originating_centre': 'cmcc',
            'system': '35',
        },
    },
    'SPSv4': {
        'dir': 'CMCC/SPSv4',
        'slug': 'C3S_cmcc_SPSv4',
        'start_year': 1993,
        'end_year': 2022,
        'args': {
            'originating_centre': 'cmcc',
            'system': '4',
        },
    },
    'GCFS2p2': {
        'dir': 'DWD/GCFS2p2',
        'slug': 'C3S_dwd_GCFS2p2',
        'start_year': 1993,
        'end_year': 2023,
        'args': {
            'originating_centre': 'dwd',
	        'system': '22',
        },
    },
    'JMA': {
        'dir': 'JMA/system3',
        'slug': 'C3S_jma_system3',
        'start_year': 1993,
        'end_year': 2020,
        'args': {
            'originating_centre': 'jma',
	        'system': '3',
        },
    },
    'UKMO': {
        'dir': 'UKMO/GloSea6-GC2/System604',
        'slug': 'C3S_ukmo_system604',
        'start_year': 1993,
        'end_year': 2016,
        'args': {
            'originating_centre': 'ukmo',
	        'system': '604',
        },
    },
}

def has_p(v):
    '''True iff variable v has a pressure_level dimension'''
    return v in ['z', 'v', 'u']

def dataset_name(v):
    if has_p(v):
        name = 'seasonal-monthly-pressure-levels'
    else:
        name = 'seasonal-monthly-single-levels'
    return name


if __name__ == '__main__':
    description = "Model to use. Available options:\n" + "\n".join(
                    f"  {k:<12} (System: {v['args']['system']},\tHindcast-Period: {v['start_year']}–{v['end_year']})"
                    for k, v in models.items()
                )
    parser = argparse.ArgumentParser(
                description=description,
                formatter_class=argparse.RawTextHelpFormatter
        )
    parser.add_argument('--dir', default=topdir,
                        metavar='directory',
                        help=f"Destination directory? Default is {topdir}"
                        )
    parser.add_argument('--hindcasts', action='store_true',
                        help="download historical data? (See period time on the list above)"
                        )
    parser.add_argument('--current_month', action='store_true',
                        help=("It enables the download of the current month's entire hindcast history. \n"
                             "For example, if the current month is February and the model has historical \n"
                             " data available from 1982 to 2020, current_month would download February 1982–2020." )
                        )
    parser.add_argument('model', choices=models.keys(),
                        help="Model key. See list above."
                        )
    args = parser.parse_args()

    model = models[args.model]

    if args.hindcasts:
        hcst_fcst = 'hcast'
        if args.current_month:
            months = [ datetime.datetime.today().strftime('%m') ]
        else:
            months = [ "%02d" % x for x in range(1,13) ]
        years = [str(x) for x in range(model['start_year'], model['end_year']+1)]
    else:
        hcst_fcst = 'fcast'
        months = [ datetime.datetime.today().strftime('%m') ]
        years = [ datetime.datetime.today().strftime('%Y') ]

    dirname = f"{args.dir}/{model['dir']}/{case[hcst_fcst]}"
    print(dirname)

    c = cdsapi.Client()

    for yr in years:
        for mon in months:
            print('')
            print (calendar.month_name[int(mon)]+' '+yr)
            postfix = f'_{model["slug"]}_{hcst_fcst}_mon_mean_{yr}{mon}.grb'

            for short_var, long_var in vars.items():
                filepath = f'{dirname}/{short_var}{postfix}'
                if os.path.exists(filepath):
                    print(f'{filepath} already downloaded')
                else:
                    print(f'downloading {filepath}...')
                    args = common_args | model['args'] | dict(
                        variable=long_var,
                        year=yr,
                        month=mon,
                        #data_format="netcdf",
                    )
                    if has_p(short_var):
                        args['pressure_level'] = pressure_levels
                        # cdsapi writes directly to the destination file, so
                        # if it crashes mid-download, it leaves a partial file.
                        # Avoid that by writing to a tempfile and moving it
                        # into place when the download is finished.
                    temppath = f'{filepath}.tmp'
                    c.retrieve(dataset_name(short_var), args, temppath)
                    os.rename(temppath, filepath)
