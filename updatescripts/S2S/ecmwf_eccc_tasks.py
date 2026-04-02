from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

class ECCCModel(ECMWFModelTaskBase):
    """
    Model used to download the ECCC models from the ECMWFDataServer()
    References:
        https://confluence.ecmwf.int/display/S2S/ECMWF+Model
        https://apps.ecmwf.int/datasets/data/s2s-realtime-instantaneous-accum-cwao/
    """
    first_date = datetime.datetime(2024, 6, 13)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 21

    # weekdays: days of week data is available
    weekdays = ["Mon", "Thu"]

    origin = "cwao"

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = ECCCModel.weekdays

        super().__init__(start, end, weekdays, goback, ECCCModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/ECCC/REL_GEPS8/PF/"
        cf_toplevel = f"{self.S2S_toplevel}/ECCC/REL_GEPS8/CF/"

        self.all_models["ECCC_REL_PF"] = []
        self.all_models["ECCC_REL_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            self.all_models["ECCC_REL_PF"].extend([
                {
                    "min_size": 1817774400,
                    "target": f"{pf_toplevel}/eccc_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 318110520,
                    "target": f"{pf_toplevel}/eccc_rel_pf_pl_q{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "133",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 45444360,
                    "target": f"{pf_toplevel}/eccc_rel_pf_pl_w{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "135",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 745712760,
                    "target": f"{pf_toplevel}/eccc_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/174008/228143/228144/228228",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 310000000,
                    "target": f"{pf_toplevel}/eccc_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "31/33/34/136/167/168/228032/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 659521980,
                    "target": f"{pf_toplevel}/eccc_rel_pf_o2d{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 73280220,
                    "target": f"{pf_toplevel}/eccc_rel_pf_o2d1_{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "151163",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 73280220,
                    "target": f"{pf_toplevel}/eccc_rel_pf_o2d2_{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "151225",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                }
            ])

            self.all_models["ECCC_REL_CF"].extend([
                {
                    "min_size": 90888720,
                    "target": f"{cf_toplevel}/eccc_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "130/131/132/156",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 15905526,
                    "target": f"{cf_toplevel}/eccc_rel_cf_pl_q{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "133",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 2272218,
                    "target": f"{cf_toplevel}/eccc_rel_cf_pl_w{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "500",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "135",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 41830074,
                    "target": f"{cf_toplevel}/eccc_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/174008/228002/228143/228144/228228",
                    "step": "24/to/936/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 10000000,
                    "target": f"{cf_toplevel}/eccc_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "31/33/34/136/167/168/228032/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 32976099,
                    "target": f"{cf_toplevel}/eccc_rel_cf_o2d{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {   # depth of 20C isotherm
                    "min_size": 3664011,
                    "target": f"{cf_toplevel}/eccc_rel_cf_o2d1_{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "151163",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {   # 9 mixed layer thickness
                    "min_size": 3664011,
                    "target": f"{cf_toplevel}/eccc_rel_cf_o2d2_{ymd}{ymd}.grb",
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  ECCCModel.origin,
                    "param": "151225",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                }
            ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from ECCC Model.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, b yut default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = ECCCModel.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = ECCCModel(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")
