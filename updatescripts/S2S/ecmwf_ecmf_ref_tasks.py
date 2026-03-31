from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime

class ECMF_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the ECMWF hindcast models from the ECMWFDataServer()
    """
    # hindcast_start_year = 2006
    # hindcast_end_year = 2025
    model_version_offset = 18 # days
    weekdays = ["odd"]
    first_date = datetime.datetime(2015, 1, 1)

    def __init__(self, start=None, end=None, weekdays=None, goback=None, model_version_offset=None):
        if weekdays is None:
            weekdays = ECMF_REF_Model.weekdays
        if model_version_offset is None:
            model_version_offset = ECMF_REF_Model.model_version_offset

        super().__init__(start, end, weekdays, goback, model_version_offset)

        step = "0/to/1104/by/24"
        step_sfc_sfc62 = "0/to/1104/by/6"
        step_sfc_sfc61 = "6/to/1104/by/6"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104"
        number = "1/to/50"

        self.all_models["ECMF_REF_PF"] = []
        self.all_models["ECMF_REF_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            # Hindcast Years for ECMWF are always the preceding 20 years
            for year in range(d.year-20, d.year):
                hdate_y_m_d = f"{year}-{d.month:02d}-{d.day:02d}"
                hdate_ymd = f"{year}{d.month:02d}{d.day:02d}"

                toplevel = f"{self.S2S_toplevel}/ECMF/REF/CF/{d.year}"
                modeltype = f"ECMF_REF_CF"
                self.all_models[modeltype].extend([
                    {
                        "actual_size": 76915080 if d < datetime.datetime(2015,5,14) else 109545720,
                        "target": f"{toplevel}/ecmf_ref_cf_pl_zuvt{ymd}{hdate_ymd}.grb",
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "130/131/132/156",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect" : "any",
                    }, #1
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_pl_q{ymd}{hdate_ymd}.grb",
                        "actual_size": 13460139 if d < datetime.datetime(2015,5,14) else 19170501,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "133",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },  # 2
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_pl_w{ymd}{hdate_ymd}.grb",
                        "actual_size": 1922877 if d < datetime.datetime(2015,5,14) else 2738643 if d <= datetime.datetime(2016, 9, 29) else 27386430,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "135",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },  # 3
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_sfc_sfc{ymd}{hdate_ymd}.grb",
                        "min_size": 38021924 if d < datetime.datetime(2015,5,14) else 45308462,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "43/121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/174008/228143/228144/228205/228228",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },  # 4
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                        "actual_size": 21451824,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "121/122",
                        "step": step_sfc_sfc61,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },  # 4-2
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_sfc_sfc62_{ymd}{hdate_ymd}.grb",
                        "actual_size": 32285655 if d >= datetime.datetime(2020, 11, 23) else 16203411,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "165/166/228228",
                        "step": step_sfc_sfc62,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },  # 4-3
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_da_sfc{ymd}{hdate_ymd}.grb",
                        "min_size": 20600000,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },  # 5
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_pt_pv{ymd}{hdate_ymd}.grb",
                        "actual_size": 1922877 if d < datetime.datetime(2015,5,14) else 2738643,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "320",
                        "levtype": "pt",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "60",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },  # 6
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_o2d{ymd}{hdate_ymd}.grb",
                        "actual_size": 37937976 if d < datetime.datetime(2023, 7, 13) else 37945216,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "o2d",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "grid": "1.0/1.0",
                        "expect": "any",
                    },  # 7
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_o2d1_{ymd}{hdate_ymd}.grb",
                        "actual_size": 4331240 if d < datetime.datetime(2023, 7, 13) else 4334488,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "o2d",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "151163",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "grid": "1.0/1.0",
                        "expect": "any",
                    },  # 8 depth of 20C isotherm
                    {
                        "target": f"{toplevel}/ecmf_ref_cf_o2d2_{ymd}{hdate_ymd}.grb",
                        "actual_size": 4331240 if d < datetime.datetime(2023, 7, 13) else 4334488,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "o2d",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "151225",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "grid": "1.0/1.0",
                        "expect": "any",
                    }  # 9 mixed layer thickness
                ])

                toplevel = f"{self.S2S_toplevel}/ECMF/REF/PF/{d.year}"
                modeltype = f"ECMF_REF_PF"
                self.all_models[modeltype].extend([
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_pl_zuvt{ymd}{hdate_ymd}.grb",
                        "actual_size": 307660320 if d < datetime.datetime(2015,5,14) else 1095457200,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "130/131/132/156",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect" : "any",
                    }, #1
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_pl_q{ymd}{hdate_ymd}.grb",
                        "actual_size": 53840556 if d < datetime.datetime(2015,5,14) else 191705010,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "133",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },  # 2
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_pl_w{ymd}{hdate_ymd}.grb",
                        "actual_size": 7691508 if d < datetime.datetime(2015,5,14) else 27386430 if d <= datetime.datetime(2016, 9, 29) else 273864300,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "135",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },  # 3
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_sfc_sfc{ymd}{hdate_ymd}.grb",
                        "min_size": 141292824 if d < datetime.datetime(2015,5,14) else 453000000,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/174008/228143/228144/228205/228228",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },  # 4
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                        "actual_size": 214518240,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "121/122",
                        "step": step_sfc_sfc61,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },  # 4-2
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_sfc_sfc62_{ymd}{hdate_ymd}.grb",
                        "actual_size": 162034110 if d < datetime.datetime(2020, 11, 26) else 322856550,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "165/166/228228",
                        "step": step_sfc_sfc62,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },  # 4-3
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_da_sfc{ymd}{hdate_ymd}.grb",
                        "min_size": 82400000,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },  # 5
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_pt_pv{ymd}{hdate_ymd}.grb",
                        "actual_size": 7691508 if d < datetime.datetime(2015,5,14) else 27386430,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "320",
                        "levtype": "pt",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "60",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },  # 6
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_o2d{ymd}{hdate_ymd}.grb",
                        "actual_size": 379379760 if d < datetime.datetime(2023,7,13) else 379452160,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "o2d",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "grid": "1.0/1.0",
                        "expect": "any",
                    },  # 7
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_o2d1_{ymd}{hdate_ymd}.grb",
                        "min_size": 43312400 if d < datetime.datetime(2023,7,13) else 43344880,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "o2d",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "151163",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "grid": "1.0/1.0",
                        "expect": "any",
                    },  # 8 depth of 20C isotherm
                    {
                        "target": f"{toplevel}/ecmf_ref_pf_o2d2_{ymd}{hdate_ymd}.grb",
                        "min_size": 43312400 if d < datetime.datetime(2023,7,13) else 43344880,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "o2d",
                        "model": "glob",
                        "number": number,
                        "origin": "ecmf",
                        "param": "151225",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "grid": "1.0/1.0",
                        "expect": "any",
                    }  # 9 mixed layer thickness
                ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check reforecast model data from ECMWF.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Will use model default if non is specified.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD.  Will only run 1 day if not defined")
    args = parser.parse_args()
    if args.start is None:
        start = ECMF_REF_Model.first_date
        end = datetime.datetime.now()
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    model = ECMF_REF_Model(start, end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])