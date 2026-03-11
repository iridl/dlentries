from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime

class KMA_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the KMA hindcast models from the ECMWFDataServer()
    """
    first_date = datetime.datetime(2020, 1, 1)

    hindcast_start_year = 1993
    hindcast_end_year = 2016
    model_version_offset = 14
    weekdays = ["1", "9", "17", "25"]

    def __init__(self, start=None, end=None, weekdays=None, goback=None, model_version_offset=None):
        if weekdays is None:
            weekdays = KMA_REF_Model.weekdays
        if model_version_offset is None:
            model_version_offset = KMA_REF_Model.model_version_offset

        super().__init__(start, end, weekdays, goback, model_version_offset)

        step = "0/to/1104/by/24"
        step_sfc_sfc61 = "6/to/1440/by/6"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440"
        number = "1/to/6"

        self.all_models["KMA_REF_PF"] = []
        self.all_models["KMA_REF_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            for year in range(KMA_REF_Model.hindcast_start_year, KMA_REF_Model.hindcast_end_year + 1):
                hdate_y_m_d = f"{year}-{d.month:02d}-{d.day:02d}"
                hdate_ymd = f"{year}{d.month:02d}{d.day:02d}"
                for ftype in ["cf", "pf"]:
                    toplevel = f"{self.S2S_toplevel}/KMA/REF/{ftype.upper()}/{d.year}"
                    modeltype = f"KMA_REF_{ftype.upper()}"
                    self.all_models[modeltype].extend([
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_pl_zuvt{ymd}{hdate_ymd}.grb",
                        "min_size": 109545720,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "rksl",
                        "param": "130/131/132/156",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{ftype}",
                        "expect" : "any",
                    }, #1
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_pl_q{ymd}{hdate_ymd}.grb",
                        "min_size": 19170501,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/20/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "rksl",
                        "param": "133",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{ftype}",
                        "expect": "any",
                    },  # 2
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_pl_w{ymd}{hdate_ymd}.grb",
                        "min_size": 27386430,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "rksl",
                        "param": "135",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{ftype}",
                        "expect": "any",
                    },  # 3
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_sfc_sfc{ymd}{hdate_ymd}.grb",
                        "min_size": 54508004,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "rksl",
                        "param": "121/122/134/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{ftype}",
                        "expect": "any",
                    },  # 4
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                        "min_size": 21451824,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "rksl",
                        "param": "121/122/165/166/228228",
                        "step": step_sfc_sfc61,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{ftype}",
                        "expect": "any",
                    },  # 4-2
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_da_sfc{ymd}{hdate_ymd}.grb",
                        "min_size": 29310000,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "rksl",
                        "param": "31/34/167/168/235/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{ftype}",
                        "expect": "any",
                    }
                ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from KMA REF Model.")
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