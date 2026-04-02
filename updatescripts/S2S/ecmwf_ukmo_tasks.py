from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime


class UKMOModel(ECMWFModelTaskBase):
    """
    Tasks for the UKMO Models downloaded from ECMWF
    https://apps.ecmwf.int/datasets/data/s2s-realtime-instantaneous-accum-egrr/levtype=sfc/type=cf/
    """
    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 21

    # weekdays: days of week data is available
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = UKMOModel.weekdays

        super().__init__(start, end, weekdays, goback, UKMOModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/UKMO/REL/PF"
        cf_toplevel = f"{self.S2S_toplevel}/UKMO/REL/CF"

        self.all_models["UKMO_REL_PF"] = []
        self.all_models["UKMO_REL_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["UKMO_REL_PF"].extend([
                {   # _rel_pf_sfc_sfc
                    "target": f"{pf_toplevel}/ukmo_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "actual_size": 209722956,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/3",
                    "origin": "egrr",
                    "param": "121/122/134/165/166/169/175/176/177/179/228143/228144/228228",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {   # _rel_pf_pl_zuvt
                    "target": f"{pf_toplevel}/ukmo_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "min_size": 214570000,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/3",
                    "origin": "egrr",
                    "param": "130/131/132/156",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {   # _rel_pf_pl_q
                    "target": f"{pf_toplevel}/ukmo_rel_pf_pl_q{ymd}{ymd}.grb",
                    "actual_size": 114639252,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/3",
                    "origin": "egrr",
                    "param": "133",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {   # _rel_pf_pl_w
                    "target": f"{pf_toplevel}/ukmo_rel_pf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 16377036,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/3",
                    "origin": "egrr",
                    "param": "135",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {   # _rel_pf_da_sfc
                    "target": f"{pf_toplevel}/ukmo_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 86687820,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/3",
                    "origin": "egrr",
                    "param": "31/34/167/168/235/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                }
            ])

            self.all_models["UKMO_REL_CF"].extend([
                {   # _rel_cf_sfc_sfc
                    "target": f"{cf_toplevel}/ukmo_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "actual_size": 80825676,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": "egrr",
                    "param": "121/122/134/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {   # _rel_cf_pl_zuvt
                    "target": f"{cf_toplevel}/ukmo_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "min_size": 214400000,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": "egrr",
                    "param": "130/131/132/156",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                { # _rel_cf_pl_g
                    "target": f"{cf_toplevel}/ukmo_rel_cf_pl_q{ymd}{ymd}.grb",
                    "actual_size": 38213084,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": "egrr",
                    "param": "133",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect" : "any",
                },
                {   # _rel_cf_pl_w
                    "target": f"{cf_toplevel}/ukmo_rel_cf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 5459012,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": "egrr",
                    "param": "135",
                    "step": "0/to/1440/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {   # _rel_cf_da_sfc
                    "target": f"{cf_toplevel}/ukmo_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 28895940 if d < datetime.datetime(2021, 2, 2) else \
                        28900620 if d < datetime.datetime(2025, 2, 19) else 28903320,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": "egrr",
                    "param": "31/34/167/168/235/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                }
            ])

if __name__ == '__main__':
    import logging
    start = datetime.datetime(2015, 12, 1)
    model = UKMOModel(start=start, end=datetime.datetime.now())
    mytasks = model.get_tasks(prune=True, dryrun=True)
    for t in mytasks:
        print(t['target'])