#!/usr/local/bin/condarun updatescripts

# Hindcasts (aka Retrospectives)
# layout is the same with tar archives for each calendar month and variable, 
# eg  nov.precip.1991_2020.tar which contain starts in the previous month. 

import update_utilities as uu
from pathlib import Path

BASE_URL = "https://data.nas.nasa.gov/geos-s2s-3/NMME/ensembles/monthly_native"
DEST_DIR = Path("/Data/data23/NMME/NASA_GEOS-S2S-3/Hindcast_retro")
MONTHS = ["jan", "feb", "mar", "apr", "may", "jun",
          "jul", "aug", "sep", "oct", "nov", "dec" ]
VARS = [
    "at", "evpintr", "evpsoil", "evptrans", "olr", "precip", "slp", "sst", "t200", "t2mmax",
    "t2mmin", "t850", "taux", "tauy", "u200", "u850", "v200", "v850", "wet3", "z200", "z500"
]

not_found = []
for mon in MONTHS:
    dest_dir = DEST_DIR / mon
    dest_dir.mkdir(mode=uu.DIR_MODE, parents=True, exist_ok=True)
    for var in VARS:
        file_name = f"{mon}.{var}.1991_2020.tar"
        download_status = uu.download_file(
            dest_dir, file_name, f"{BASE_URL}/{mon}/{file_name}",
        )
        print(download_status["message"])
        if download_status["flag"] >= 0:
            unpacked_dir, message = uu.unpack(dest_dir / file_name, keep_packed_file=False)
            print(message)
            # We put all vars together in the month directory
            for file in unpacked_dir.glob('*'):
                message = uu.add_to_dataset(file, new_path=(dest_dir / file.name))
                print(message)
            unpacked_dir.rmdir()
        else:
            print("tarfile was not downloaded")
            not_found.append(f"{mon}/{file_name}: {download_status['message']}")

(DEST_DIR / "variables_not_found.txt").write_text("\n".join(not_found))
