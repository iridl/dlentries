#!/usr/local/bin/condarun updatescripts

from pathlib import Path
import requests
import sys
import datetime

# Used on 2023/10/13-14 to download all but Pentad files
# The loop on PRODUCTS_CTL is not really working
# because the while will eventually have requests.get
# not find the url_file for all but the Daily case
# and trigger the exit. The end of the while need be smarter than that.

URL_PATH = f'https://ftp.cpc.ncep.noaa.gov/precip/CBO_V1'
DEST_PATH = Path(f'/Data/data6/noaa/cpc/precip/CBO_V1')

PRODUCTS_CTL = {
    "0.25deg-DLY": "d1",
    "0.25deg-MON": "m1",
    "0.25deg-WKLY": "w1",
    "1deg-DLY": "d2",
    "1deg-MON": "m2",
    "1deg-WKLY": "w2",
    "2.5deg-DLY": "d3",
    "2.5deg-MON": "m3",
    "2.5deg-WKLY": "w3",
    "512x256-DLY": "d4",
    "512x256-MON": "m4",
    "512x256-WKLY": "w4",
}

for p in PRODUCTS_CTL:
    url_product = f'{URL_PATH}/{p}'
    # Read ctl file to determine last date of Final files
    url_ctl = f'{url_product}/CTL/{PRODUCTS_CTL[p]}.CBO_V1_{p}.lnx.ctl'
    date_length = 10
    date_format = "%Y.%m.%d"
    if p.find("MON") > 0 :
        date_length = 7
        date_format = "%Y.%m"
    with requests.get(url_ctl) as r:
        if r.status_code == 404:
            print(f'could not find {url_ctl}')
            sys.exit()
        else:
            r.raise_for_status()
        Final_version_date_idx = r.text.find("~")+1
        Final_version_date = datetime.datetime.strptime(
            r.text[Final_version_date_idx:Final_version_date_idx+date_length],
            date_format,
        )
    #Get ready to loop on dates of files
    prod_type = "Final"
    dest_product = DEST_PATH / p
    file_date = (
        datetime.datetime(1991, 1, 1)
        if p.find("WKLY") == -1
        else datetime.datetime(1991, 1, 6)
    )
    while file_date < datetime.datetime.today():
        file_name = (
            f'CBO_V1_{p}.lnx.{file_date.strftime("%Y%m%d")}'
            if p.find("MON") == -1
            else f'CBO_V1_{p}.lnx.{file_date.strftime("%Y%m")}'
        )
        print(file_name)
        url_file = f'{url_product}/{file_date.year}/{file_name}'
        dest_prod_year = dest_product / f'{file_date.year}'
        dest_prod_year.mkdir(exist_ok=True)
        if file_date > Final_version_date :
            prod_type = "NRT"
        dest_prod_type = dest_prod_year / prod_type
        dest_prod_type.mkdir(exist_ok=True)
        dest_prod_file = dest_prod_type / file_name
        with requests.get(url_file, stream=True) as r:
            if r.status_code == 404:
                print(f'can not find {url_file}')
                sys.exit()
            else:
                r.raise_for_status()
            with dest_prod_file.open("wb") as f:
                for chunk in r.iter_content(16*1024):
                    f.write(chunk)
        assert dest_prod_file.is_file(), 'download_failed'
        #Increment next file date
        if p.find("MON") >= 0:
            if file_date.month == 12:
                file_date = file_date.replace(year=file_date.year+1, month=1)
            else:
                file_date = file_date.replace(month=file_date.month+1)
        elif p.find("WKLY") >= 0:
            file_date = file_date + datetime.timedelta(days=7)
        else:
            file_date = file_date + datetime.timedelta(days=1)
