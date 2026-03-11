from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

class KMAModel(ECMWFModelTaskBase):
    """
    Model used to download the KMA model data from the ECMWFDataServer()
    """

    # while the first download date is actually 2016-11-02, the actual_size numbers are inconsistent before then
    first_date = datetime.datetime(2016, 12, 22)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = KMAModel.weekdays

        super().__init__(start, end, weekdays, goback, KMAModel.data_access_delay)

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            pf_1p5_toplevel = f"{self.S2S_toplevel}/KMA/REL_new/PF/{d.year}"
            cf_1p5_toplevel = f"{self.S2S_toplevel}/KMA/REL_new/CF/{d.year}"

            ### 1.5x1.5 new version
            self.all_models["KMA_REL_1p5_CF"] = [
                {
                    "target": f"{cf_1p5_toplevel}/kma_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "actual_size": 218360480 if d < datetime.datetime(2022, 2, 22) else 221874080,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    "param": "130/131/132/156",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },

                {
                    "target": f"{cf_1p5_toplevel}/kma_rel_cf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 5459012 if d < datetime.datetime(2022, 2, 22) else 55468520,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    "param": "135",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },

                {
                    "target": f"{cf_1p5_toplevel}/kma_rel_cf_pl_q{ymd}{ymd}.grb",
                    "actual_size": 38213084 if d < datetime.datetime(2022, 2, 22) else 38827964 if d < datetime.datetime(2023, 5, 27) else 55468520,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    "param": "133",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },

                {
                    "target": f"{cf_1p5_toplevel}/kma_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "min_size": 42961920 if d < datetime.datetime(2020, 8, 1) else 75187674,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    # "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/174008/228143/228144/228205/228228",
                    "param": "121/122/134/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },

                {
                    "target": f"{cf_1p5_toplevel}/kma_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 14573880 if d < datetime.datetime(2017, 11, 1) \
                        else 19944840 if d < datetime.datetime(2020, 8, 1) \
                        else 29183580 if d < datetime.datetime(2022, 2, 22) else 29332620,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    # "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                    "param": "31/34/167/168/235/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                }
            ]

            self.all_models["KMA_REL_1p5_PF"] = [
                {
                    "target": f"{pf_1p5_toplevel}/kma_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "actual_size": 655081440 if d < datetime.datetime(2022, 2, 22) else 665622240 if d < datetime.datetime(2023, 6, 1) else 1553118560,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    "param": "130/131/132/156",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_1p5_toplevel}/kma_rel_pf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 16377036 if d < datetime.datetime(2022, 2, 22) else 166405560 if d < datetime.datetime(2023, 6, 1) else 388279640,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    "param": "135",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },

                {
                    "target": f"{pf_1p5_toplevel}/kma_rel_pf_pl_q{ymd}{ymd}.grb",
                    "actual_size": 114639252 if d < datetime.datetime(2022, 2, 22) else 116483892 if d < datetime.datetime(2023, 6, 1) else 388279640,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    "param": "133",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },

                {
                    "target": f"{pf_1p5_toplevel}/kma_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "min_size": 128885760 if d < datetime.datetime(2020, 8, 1) \
                        else 225563037 if d < datetime.datetime(2022, 2, 22) \
                        else 229191840 if d < datetime.datetime(2023, 6, 1) else 612436888,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    "param": "121/122/134/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_1p5_toplevel}/kma_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 43721640 if d < datetime.datetime(2017, 11, 1) \
                        else 59834520 if d < datetime.datetime(2020, 8, 1) \
                        else 87550740 if d < datetime.datetime(2022, 2, 22) \
                        else 87997860 if d < datetime.datetime(2023, 6, 1) \
                        else 205328340,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/7",
                    "origin": "rksl",
                    # "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                    "param": "31/34/167/168/235/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                }
            ]

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from KMA Model.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, by default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = KMAModel.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    elif args.start is None:
        end = datetime.datetime.now()

    print(f"Start: {start}, End: {end}")
    model = KMAModel(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")