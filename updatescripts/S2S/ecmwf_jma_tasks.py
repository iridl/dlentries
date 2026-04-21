from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

class JMAModel(ECMWFModelTaskBase):
    """
    Tasks for the JMA Models downloaded from ECMWF
    """
    first_date = datetime.datetime(2016, 1, 1)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    origin = "rjtd"
    
    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = JMAModel.weekdays

        super().__init__(start, end, weekdays, goback, JMAModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/JMA/REL/PF"
        cf_toplevel = f"{self.S2S_toplevel}/JMA/REL/CF"

        self.all_models["JMA_REL_CF"] = []
        self.all_models["JMA_REL_PF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["JMA_REL_CF"].extend([
                {
                    "target": f"{cf_toplevel}/jma_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "actual_size": 79236320 if d < datetime.datetime(2017, 3, 22) else 76905840 if d < datetime.datetime(2023, 2, 19) else 79236320,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/jma_rel_cf_pl_q{ymd}{ymd}.grb",
                    "actual_size": 13866356 if d < datetime.datetime(2017, 3, 22) else 13458522 if d < datetime.datetime(2023, 2, 19) else 13866356,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "133",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/jma_rel_cf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 1980908 if d < datetime.datetime(2017, 3, 22) else 1922646 if d < datetime.datetime(2023, 2, 19) else 19809080,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "135",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/jma_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "actual_size": 31704320 if d < datetime.datetime(2017, 3, 22) else 30771840 if d < datetime.datetime(2023, 2, 19) else 47554848,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/228002/228143/228228",
                    "step": "12/to/816/by/12",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/jma_rel_cf_sfc_sfc6_{ymd}{ymd}.grb",
                    "actual_size": 15154360 if d < datetime.datetime(2023, 2, 19) else 15620648,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "121/122",
                    "step": "6/to/804/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{cf_toplevel}/jma_rel_cf_sfc_sfc62_{ymd}{ymd}.grb",
                    "actual_size": 5768730 if d < datetime.datetime(2023, 2, 19) else 23424540,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "165/166/228228",
                    "step": "6/to/804/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },

                {
                    "target": f"{cf_toplevel}/jma_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 14118060 if d < datetime.datetime(2017, 3, 22) else 13674112 if d < datetime.datetime(2023, 3, 8) else 13608772,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "31/34/136/167/168/235/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                }
            ])
            self.all_models["JMA_REL_PF"].extend([
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "actual_size": 1901671680 if d < datetime.datetime(2017, 3, 22) else 3768386160 if d < datetime.datetime(2023, 2, 19) else 316945280,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_pl_z{ymd}{ymd}.grb",
                    "actual_size": 942096540 if d < datetime.datetime(2023, 2, 19) else 79236320,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "156",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_pl_t{ymd}{ymd}.grb",
                    "actual_size": 942096540 if d < datetime.datetime(2023, 2, 19) else 79236320,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "130",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_pl_u{ymd}{ymd}.grb",
                    "actual_size": 942096540 if d < datetime.datetime(2023, 2, 19) else 79236320,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "131",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_pl_v{ymd}{ymd}.grb",
                    "actual_size": 942096540 if d < datetime.datetime(2023, 2, 19) else 79236320,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "132",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },

                {
                    "target": f"{pf_toplevel}/jma_rel_pf_pl_q{ymd}{ymd}.grb",
                    "actual_size": 332792544 if d < datetime.datetime(2017, 3, 22) else 659467578 if d < datetime.datetime(2023, 2, 19) else 55465424,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "133",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_pl_w{ymd}{ymd}.grb",
                    "actual_size": 47541792 if d < datetime.datetime(2017,3,22) else 94209654 if d < datetime.datetime(2023, 2, 19) else 79236320,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "135",
                    "step": "24/to/816/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "actual_size": 760903680 if d < datetime.datetime(2017,3,22) else 1507820160 if d < datetime.datetime(2023, 2, 19) else 174372128,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/228143/228228",
                    "step": "12/to/816/by/12",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_sfc_sfc6_{ymd}{ymd}.grb",
                    "actual_size": 60617440 if d < datetime.datetime(2023, 2, 19) else 62482592,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "121/122",
                    "step": "6/to/804/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{pf_toplevel}/jma_rel_pf_sfc_sfc62_{ymd}{ymd}.grb",
                    "actual_size": 23074920 if d < datetime.datetime(2023, 2, 19) else 93698160,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "165/166/228228",
                    "step": "6/to/804/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },

                {
                    "target": f"{pf_toplevel}/jma_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "actual_size": 338833440 if d < datetime.datetime(2017,3,22) \
                        else 670031488 if d < datetime.datetime(2022, 3, 16) \
                        else 669441920 if d < datetime.datetime(2023, 3, 8) \
                        else 54435088 if d < datetime.datetime(2026, 1, 25) \
                        else 54434544,
                    "class": JMAModel.s2s_class,
                    "dataset": JMAModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/4",
                    "origin": JMAModel.origin,
                    "param": "31/34/136/167/168/235/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                }
            ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from JMA Model.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, b yut default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = JMAModel.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = JMAModel(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")