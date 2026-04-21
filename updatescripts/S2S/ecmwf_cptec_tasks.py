from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

class CPTECModel(ECMWFModelTaskBase):
    """
    Model used to download the CPTEC models from the ECMWFDataServer cdsapi()
    """

    first_date = datetime.datetime(2023, 12, 13)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 3

    # weekdays: days of week data is available
    weekdays = ["Wed", "Thu"]

    origin = "sbsj"

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = CPTECModel.weekdays

        super().__init__(start, end, weekdays, goback, CPTECModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/CPTEC/REL/PF/"
        cf_toplevel = f"{self.S2S_toplevel}/CPTEC/REL/CF/"

        self.all_models["CPTEC_REL_PF"] = []
        self.all_models["CPTEC_REL_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["CPTEC_REL_PF"].extend([
                {
                    "min_size": 153097000,
                    "target": f"{pf_toplevel}/cptec_rel_pf_pl_z{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "156",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 153097000,
                    "target": f"{pf_toplevel}/cptec_rel_pf_pl_t{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "130",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 153097000,
                    "target": f"{pf_toplevel}/cptec_rel_pf_pl_u{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "131",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 153097000,
                    "target": f"{pf_toplevel}/cptec_rel_pf_pl_v{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "132",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 612388000,
                    "target": f"{pf_toplevel}/cptec_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 107167900,
                    "target": f"{pf_toplevel}/cptec_rel_pf_pl_q{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "133",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 153097000,
                    "target": f"{pf_toplevel}/cptec_rel_pf_pl_w{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "135",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 275675400,
                    "target": f"{pf_toplevel}/cptec_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 306294800,
                    "target": f"{pf_toplevel}/cptec_rel_pf_sfc_sfc6_{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "121/122/165/166/228228",
                    "step": "6/to/840/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 76590500,
                    "target": f"{pf_toplevel}/cptec_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "59/136/167/168/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
            ])

            self.all_models["CPTEC_REL_CF"].extend([
                {
                    "min_size": 61238800,
                    "target": f"{cf_toplevel}/cptec_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 10716790,
                    "target": f"{cf_toplevel}/cptec_rel_cf_pl_q{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "133",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 15309700,
                    "target": f"{cf_toplevel}/cptec_rel_cf_pl_w{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "135",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 27567540,
                    "target": f"{cf_toplevel}/cptec_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                    "step": "24/to/840/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 30629480,
                    "target": f"{cf_toplevel}/cptec_rel_cf_sfc_sfc6_{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "121/122/165/166/228228",
                    "step": "6/to/840/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 7659050,
                    "target": f"{cf_toplevel}/cptec_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "class": CPTECModel.s2s_class,
                    "dataset": CPTECModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/10",
                    "origin":  CPTECModel.origin,
                    "param": "59/136/167/168/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
            ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from CPTEC Model.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, b yut default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = CPTECModel.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = CPTECModel(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")
