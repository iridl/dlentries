#!/usr/local/bin/condarun updatescripts2

import argparse
from datetime  import datetime
from pathlib import Path
from dateutil.relativedelta import relativedelta
import update_utilities as uu
import sys



topdir = '/Data/data21/gpcc'
topurl = 'https://opendata.dwd.de/climate_environment/GPCC'

res = {
    '1p0': '10',
    '2p5': '25',
}

versions = {
    'v2020': {
        'dir': 'v2020',
        'label_owner': 'monitoring_v2020',
        'start_year': 1982,
        'end_year': 2024,
    },
    'v2022': {
        'dir': 'v2022',
        'label_owner': 'monitoring_v2022',
        'start_year': 1982,
        'end_year': 2024,
    },

}



if __name__ == '__main__':
    parser = argparse.ArgumentParser(
                formatter_class=argparse.RawTextHelpFormatter
        )
    parser.add_argument('--dir', default=topdir,
                        metavar='directory',
                        help=f"Directory to process. Default is {topdir}"
                        )
    parser.add_argument('--historical', action='store_true',
                        help="Use historical data. Versions:\n" + "\n".join(
                                f"  {name} ({info['start_year']}–{info['end_year']})"
                                for name, info in versions.items())
                        )
    parser.add_argument('--current_month', type=str, default=None, 
                        metavar='YYYY-MM',
                        help="Current month in YYYY-MM format (optional)"
                        )
    parser.add_argument('version', choices=versions.keys(), 
                        help="Version to use. Available options: " + ", ".join(versions.keys())
                        )
    args = parser.parse_args()

    version = versions[args.version]

    if args.historical:
        start = datetime.strptime(str(version['start_year'])+"-01-01", "%Y-%m-%d")
        end = datetime.strptime(str(version['end_year'])+"-12-10", "%Y-%m-%d")
    elif args.current_month:
        try:
            start = datetime.strptime(args.current_month, "%Y-%m")
            start = start.replace(day=1)
            end = start
        except ValueError:
            sys.exit(
                    f"Invalid format for --current_month: '{args.current_month}'. "
                    "Use the 'YYYY-MM' format with a valid month (e.g., '2024-05')."
                    )
    else:
        #The data is published with a two-month delay.
        # However, the owner does not have a regular schedule for publishing the data — 
        #  it can even be on the last day of the month in the afternoon. Therefore, the 
        #  verification is adjusted to two and three months back 
        start = datetime.today() - relativedelta(months=3)
        end = datetime.today() - relativedelta(months=2)
    
    dirname = Path(f"{args.dir}/{version['dir']}")
    if not dirname.exists():
            Path(dirname).mkdir(parents=True, exist_ok=True)
    while start <= end:
        yr=start.strftime("%Y")
        mon=start.strftime("%m")
        print(f'{yr}-{mon}')

        dirname = Path(f"{args.dir}/{version['dir']}/{yr}")
        for short_res, long_res in res.items():
            postfix = f'{version["label_owner"]}_{long_res}_{yr}_{mon}.nc.gz'
            file_target = dirname / postfix
            fileget = f'{topurl}/{version["label_owner"]}/{yr}/{postfix}'
            if file_target.with_suffix('').is_file():  
                is_downloaded = False
                print(f'{file_target} already downloaded')
            else:
                print(f'downloading {file_target}...')
                is_downloaded, message = uu.download_file(
                                            dirname, postfix, fileget,
                                            )
                print(message)
                #Always process one file
                unpacked_dir, message = uu.unpack(file_target,keep_packed_file=False)
                print(message)

        start += relativedelta(months=1)
