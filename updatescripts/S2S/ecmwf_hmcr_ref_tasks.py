from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime

class HMCR_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the HMCR hindcast models from the ECMWFDataServer()
    https://apps.ecmwf.int/datasets/data/s2s-reforecasts-instantaneous-accum-rums/levtype=sfc/type=cf/
    """
    first_date = datetime.datetime(2015, 1, 7)

    model_version_offset = 21 # days
    weekdays = ["Thu"]
    origin = "rums"

    def __init__(self, start=None, end=None, weekdays=None, goback=None, model_version_offset=None):
        if weekdays is None:
            weekdays = HMCR_REF_Model.weekdays
        if model_version_offset is None:
            model_version_offset = HMCR_REF_Model.model_version_offset

        super().__init__(start, end, weekdays, goback, model_version_offset)

        step = "0/to/1464/by/24"
        step_sfc61 = "6/to/1464/by/6"
        step_sfc62 = "0/to/1464/by/6"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440/1440-1464"
        number = "1/to/10"

        self.all_models["HMCR_REF_PF"] = []
        self.all_models["HMCR_REF_CF"] = []

        for d in self.dates:

            if d < datetime.datetime(2021, 7, 4):
                hindcast_start_year = 1985
                hindcast_end_year = 2010
            elif d < datetime.datetime(2024, 10, 17):
                hindcast_start_year = 1990
                hindcast_end_year = 2015
            else:
                hindcast_start_year = 1991
                hindcast_end_year = 2020

            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            for year in range(hindcast_start_year, hindcast_end_year + 1):
                hdate_y_m_d = f"{year}-{d.month:02d}-{d.day:02d}"
                hdate_ymd = f"{year}{d.month:02d}{d.day:02d}"

                for T in ["CF", "PF"]:
                    toplevel = f"{self.S2S_toplevel}/HMCR/REF_new/{T}/{d.year}"
                    modeltype = f"HMCR_REF_{T}"

                    self.all_models[modeltype].extend([
                        {
                            "target": f"{toplevel}/hmcr_ref_{T.lower()}_pl_zuvt{ymd}{hdate_ymd}.grb",
                            "actual_size": 130056408 if d < datetime.datetime(2022,10,14) and T=='CF' else
                            1095457200 if d < datetime.datetime(2025,7,30) and T=='CF' else
                            109545720 if T=='CF' else
                            1170507672 if d < datetime.datetime(2022,10,14) and T=='PF' else
                            985911480 if d < datetime.datetime(2025,7,30) and T=='PF' else
                            1095457200 if T=='PF' else None,
                            "class": ECMWF_REFModelTaskBase.s2s_class,
                            "dataset": HMCR_REF_Model.dataset,
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levelist": "10/50/100/200/300/500/700/850/925/1000",
                            "levtype": "pl",
                            "model": "glob",
                            "number": number,
                            "origin": HMCR_REF_Model.origin,
                            "param": "130/131/132/156",
                            "step": step,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect" : "any",
                        },
                        {
                            "actual_size": 25288746 if T=='CF' and d < datetime.datetime(2022,10,14) else
                            191705010 if T=='CF' and d < datetime.datetime(2025,7,30) else
                            19170501 if T=='CF' else
                            227598714 if T=='PF' and d < datetime.datetime(2022,10,14) else
                            191705010 if T=='PF' and d < datetime.datetime(2025,7,30) else
                            19170501 if T=='PF' else None,
                            "target": f"{toplevel}/hmcr_ref_{T.lower()}_pl_q{ymd}{hdate_ymd}.grb",
                            "class": ECMWF_REFModelTaskBase.s2s_class,
                            "dataset": HMCR_REF_Model.dataset,
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levelist": "200/300/500/700/850/925/1000",
                            "levtype": "pl",
                            "model": "glob",
                            "number": number,
                            "origin": HMCR_REF_Model.origin,
                            "param": "133",
                            "step": step,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                        {
                            "target": f"{toplevel}/hmcr_ref_{T.lower()}_sfc_sfc{ymd}{hdate_ymd}.grb",
                            "min_size": 53975106 if T == "CF" else 484978200,
                            "class": HMCR_REF_Model.s2s_class,
                            "dataset": HMCR_REF_Model.dataset,
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levtype": "sfc",
                            "model": "glob",
                            "number": number,
                            "origin": HMCR_REF_Model.origin,
                            "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/228002/228143/228144/228228",
                            "step": step,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                        {
                            "target": f"{toplevel}/hmcr_ref_{T.lower()}_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                            "min_size": 21451824 if T == "CF" else 214518240,
                            "class": HMCR_REF_Model.s2s_class,
                            "dataset": HMCR_REF_Model.dataset,
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levtype": "sfc",
                            "model": "glob",
                            "number": number,
                            "origin": HMCR_REF_Model.origin,
                            "param": "121/122",
                            "step": step_sfc61,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                        {
                            "target": f"{toplevel}/hmcr_ref_{T.lower()}_sfc_sfc62_{ymd}{hdate_ymd}.grb",
                            "min_size": 32285655 if T == "CF" else 322856550,
                            "class": HMCR_REF_Model.s2s_class,
                            "dataset": HMCR_REF_Model.dataset,
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levtype": "sfc",
                            "model": "glob",
                            "number": number,
                            "origin": HMCR_REF_Model.origin,
                            "param": "165/166/228228",
                            "step": step_sfc62,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                        {
                            "target": f"{toplevel}/hmcr_ref_{T.lower()}_da_sfc{ymd}{hdate_ymd}.grb",
                            "min_size": 22100000 if T == "CF" else 220790000,
                            "class": HMCR_REF_Model.s2s_class,
                            "dataset": HMCR_REF_Model.dataset,
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levtype": "sfc",
                            "model": "glob",
                            "number": number,
                            "origin": HMCR_REF_Model.origin,
                            "param": "31/34/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                            "step": step_da_sfc,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        }
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
        start = HMCR_REF_Model.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.end, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = HMCR_REF_Model(start=start,end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f'Total tasks are: {len(tasks)}')
