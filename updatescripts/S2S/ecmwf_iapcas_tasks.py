from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime
import datetime

class IAPCASModel(ECMWFModelTaskBase):
    """
    Model used to download the IAP-CAS models from the ECMWFDataServer()
    References:
        https://confluence.ecmwf.int/display/S2S/IAP-CAS+Model
        https://apps.ecmwf.int/datasets/data/s2s-realtime-instantaneous-accum-anso/
    """

    first_date = datetime.datetime(2021, 5, 4)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    origin = "anso"
    
    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = IAPCASModel.weekdays

        super().__init__(start, end, weekdays, goback, IAPCASModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/IAP-CAS/REL/PF/"
        cf_toplevel = f"{self.S2S_toplevel}/IAP-CAS/REL/CF/"

        self.all_models["IAP-CAS_REL_PF"] = []
        self.all_models["IAP-CAS_REL_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["IAP-CAS_REL_PF"].extend([
                {
                    "actual_size": 2837078400 if d > datetime.datetime(2024,8, 20) else 86587000,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_pl_z{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "156",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "actual_size": 2837078400 if d > datetime.datetime(2024,8, 20) else 86587000,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_pl_t{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "130",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "actual_size": 2837078400 if d > datetime.datetime(2024,8, 20) else 86587000,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_pl_u{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "131",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "actual_size": 2837078400 if d > datetime.datetime(2024,8, 20) else 86587000,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_pl_v{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "132",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "actual_size": 11348313600 if d > datetime.datetime(2024,8, 20) else 3546348000,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "actual_size": 1985954880 if d > datetime.datetime(2024,8, 20) else 620610900,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_pl_q{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "133",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "actual_size": 283707840 if d > datetime.datetime(2024,8, 20) else 88658700,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_pl_w{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "135",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 3405167000 if d > datetime.datetime(2024,8, 20) else 1064115000,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "121/122/134/165/166/169/175/176/177/179/228144/228228",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "actual_size": 5675055360 if d > datetime.datetime(2024,8, 20) else 1773454800,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_sfc_sfc6_{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "121/122/165/166/228228",
                    "step": "6/to/1560/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 1497169428 if d > datetime.datetime(2024,8, 20) else 467865450,
                    "target": f"{pf_toplevel}/iap-cas_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "31/34/167/168/235/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440/1440-1464/1464-1488/1488-1512/1512-1536/1536-1560",

                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
            ])

            self.all_models["IAP-CAS_REL_CF"].extend([
                {
                    "actual_size": 236423200,
                    "target": f"{cf_toplevel}/iap-cas_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "actual_size": 41374060,
                    "target": f"{cf_toplevel}/iap-cas_rel_cf_pl_q{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "133",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "actual_size": 5910580,
                    "target": f"{cf_toplevel}/iap-cas_rel_cf_pl_w{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "135",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "actual_size": 82762160,
                    "target": f"{cf_toplevel}/iap-cas_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "121/122/134/165/166/169/172/175/176/177/179/228002/228144/228228",
                    "step": "24/to/1560/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "actual_size": 118230320,
                    "target": f"{cf_toplevel}/iap-cas_rel_cf_sfc_sfc6_{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "121/122/165/166/228228",
                    "step": "6/to/1560/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 31191027,
                    "target": f"{cf_toplevel}/iap-cas_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "class": IAPCASModel.s2s_class,
                    "dataset": IAPCASModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/48",
                    "origin":  IAPCASModel.origin,
                    "param": "31/34/167/168/235/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440/1440-1464/1464-1488/1488-1512/1512-1536/1536-1560",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
            ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Download models from ECMWF.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, b yut default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = IAPCASModel.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = IAPCASModel(start, end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])