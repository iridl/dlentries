#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import urllib.request as urlr
import sys
import datetime
import update_utilities as uu
import re
import pandas as pd


URL_PATH = f'https://ftp.cpc.ncep.noaa.gov/precip/CBO_V1'
DEST_DIR = Path(f'/Data/data6/noaa/cpc/precip/CBO_V1')

TIME_RES = sys.argv[1] # d, m or w
TYPE = sys.argv[2] # NRT or Final

TIME_RES_NAME = {
    "d": "DLY",
    "m": "MON",
    "w": "WKLY",
}

PRODUCTS = {
    f'0.25deg-{TIME_RES_NAME[TIME_RES]}': f'{TIME_RES}1',
    f'1deg-{TIME_RES_NAME[TIME_RES]}': f'{TIME_RES}2',
    f'2.5deg-{TIME_RES_NAME[TIME_RES]}': f'{TIME_RES}3',
    f'512x256-{TIME_RES_NAME[TIME_RES]}': f'{TIME_RES}4',
}

PRODUCTS_SIZES = {
    f'0.25deg-{TIME_RES_NAME[TIME_RES]}': 8294400,
    f'1deg-{TIME_RES_NAME[TIME_RES]}': 518400,
    f'2.5deg-{TIME_RES_NAME[TIME_RES]}': 84096,
    f'512x256-{TIME_RES_NAME[TIME_RES]}': 1048576,
}


def read_ctl_dates(ctl_text, time_res, type):
    date_re = r"\d{4}\.\d{2}\.\d{2}"
    date_format = "%Y.%m.%d"
    freq = time_res.upper()
    if time_res == "m" :
        date_re = r"\d{4}\.\d{2}"
        date_format = "%Y.%m"
        freq = f'{freq}S'
    dates = re.findall(date_re, ctl_text)
    if len(dates) != 4 :
        date_list = None
    else:
        dates = [datetime.datetime.strptime(d, date_format) for d in dates]
        if type == "NRT" :
            start_date = dates[2]
            end_date = dates[3]
        else:
            start_date = dates[0]
            end_date = dates[1]
        date_list = pd.date_range(start_date, end_date, freq=freq)
    return date_list


for p in PRODUCTS:
    url_product = f'{URL_PATH}/{p}'
    url_ctl = f'{url_product}/CTL/{PRODUCTS[p]}.CBO_V1_{p}.lnx.ctl'
    dest_product = DEST_DIR / p
    date_format_file = "%Y%m" if TIME_RES == "m" else "%Y%m%d"
    with urlr.urlopen(url_ctl) as r:
        if r.status != 200:
            print(f'Trying to get {url_ctl} returned status {r.status}')
        else:
            ctl_text = r.read().decode()
            date_list = read_ctl_dates(ctl_text, TIME_RES, TYPE)
            #List of files expected on our server
            #according to ctl file on provider's server
            expected_files = [
                dest_product / f'{d.year}' / TYPE
                / f'CBO_V1_{p}.lnx.{d.strftime(date_format_file)}' for d in date_list
            ]
            #List of current files on our server
            current_files = sorted(dest_product.glob(f'*/{TYPE}/*'))
            #list of missing files to try and download
            missing_files = sorted(set(expected_files).difference(current_files))
            for file in missing_files :
                print(file)
                destination_dir = file.parent
                destination_dir.mkdir(parents=True, exist_ok=True)
                is_downloaded, message = uu.download_file(
                    destination_dir, file.name,
                    f'{url_product}/{file.parent.parent.stem}/{file.name}',
                    expected_file_size=PRODUCTS_SIZES[p],
                )
                print(message)
                
