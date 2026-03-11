from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

class NCEPModel(ECMWFModelTaskBase):
    """
    Download NCEP Data from ECMWF
    """

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = NCEPModel.weekdays

        super().__init__(start, end, weekdays, goback, NCEPModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/NCEP/REL/PF"
        cf_toplevel = f"{self.S2S_toplevel}/NCEP/REL/CF"

        self.all_models["NCEP_REL_PF"] = []
        self.all_models["NCEP_REL_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["NCEP_REL_PF"].extend([
                {
                    "target": f"{pf_toplevel}/ncep_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15",
                    "origin": "kwbc",
                    "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/174008/228143/228144/228228",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/ncep_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15",
                    "origin": "kwbc",
                    "param": "130/131/132/156",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/ncep_rel_pf_pl_q{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15",
                    "origin": "kwbc",
                    "param": "133",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/ncep_rel_pf_pl_w{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15",
                    "origin": "kwbc",
                    "param": "135",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/ncep_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15",
                    "origin": "kwbc",
                    "param": "31/34/59/136/167/168/235/228086/228087/228095/228096/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/ncep_rel_pf_pt_pv{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "320",
                    "levtype": "pt",
                    "model": "glob",
                    "number": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15",
                    "origin": "kwbc",
                    "param": "60",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                }
            ])
            self.all_models["NCEP_REL_CF"].extend([
                {
                    "target": f"{cf_toplevel}/ncep_rel_cf_sfc_multvars{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": "kwbc",
                    "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/174008/228143/228228",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/ncep_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": "kwbc",
                    "param": "43/121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/174008/228002/228143/228228",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/ncep_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": "kwbc",
                    "param": "130/131/132/156",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/ncep_rel_cf_pl_q{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": "kwbc",
                    "param": "133",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/ncep_rel_cf_pl_w{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "origin": "kwbc",
                    "param": "135",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/ncep_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": "kwbc",
                    "param": "31/34/59/136/167/168/235/228086/228087/228095/228096/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/ncep_rel_cf_pt_pv{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "320",
                    "levtype": "pt",
                    "model": "glob",
                    "origin": "kwbc",
                    "param": "60",
                    "step": "0/24/48/72/96/120/144/168/192/216/240/264/288/312/336/360/384/408/432/456/480/504/528/552/576/600/624/648/672/696/720/744/768/792/816/840/864/888/912/936/960/984/1008/1032/1056",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                }
            ])

if __name__ == '__main__':
    import logging
    start = datetime.datetime(2015, 1, 1)
    model = NCEPModel(start=start, end=datetime.datetime.now())
    # print(model.dates)
    mytasks = model.get_tasks(prune=True, dryrun=True)
    for t in mytasks:
        print(t['target'])