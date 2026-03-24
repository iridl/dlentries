from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime


class KMA_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the KMA hindcast models from the ECMWFDataServer()
    https://apps.ecmwf.int/datasets/data/s2s-reforecasts-instantaneous-accum-rksl/levtype=sfc/type=cf/
    """
    first_date = datetime.datetime(2016, 11, 1)

    model_version_offset = 18  # days
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    def __init__(self, start=None, end=None, weekdays=None, goback=None, model_version_offset=None):
        if weekdays is None:
            weekdays = KMA_REF_Model.weekdays
        if model_version_offset is None:
            model_version_offset = KMA_REF_Model.model_version_offset

        super().__init__(start, end, weekdays, goback, model_version_offset)

        normal_step = "0/to/1440/by/24"
        step_sfc61 = "6/to/1440/by/6"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440"
        number = "1/to/6"

        self.all_models["KMA_REF_PF"] = []
        self.all_models["KMA_REF_CF"] = []

        for d in self.dates:
            if d < datetime.datetime(2020, 9, 1):
                hindcast_start_year = 1991
                hindcast_end_year = 2010
            elif d < datetime.datetime(2022, 3, 25):
                hindcast_start_year = 1991
                hindcast_end_year = 2016
            else:
                hindcast_start_year = 1993
                hindcast_end_year = 2016

            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            for year in range(hindcast_start_year, hindcast_end_year + 1):
                hdate_y_m_d = f"{year}-{d.month:02d}-{d.day:02d}"
                hdate_ymd = f"{year}{d.month:02d}{d.day:02d}"

                toplevel = f"{self.S2S_toplevel}/KMA/REF_new/CF/{d.year}"
                self.all_models['KMA_REF_CF'].extend([
                    {
                        "target": f"{toplevel}/kma_ref_cf_pl_zuvt{ymd}{hdate_ymd}.grb",
                        "actual_size": 151033560 if d < datetime.datetime(2017, 1, 1) else \
                            218377560 if d < datetime.datetime(2022, 3, 25) else \
                                221891160,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "130/131/132/156",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/kma_ref_cf_pl_q{ymd}{hdate_ymd}.grb",
                        "actual_size": 38216073 if d < datetime.datetime(2022, 3, 25) else \
                            55472790 if d < datetime.datetime(2025, 9, 1) else 49925511,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/20/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "133",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/kma_ref_cf_pl_w{ymd}{hdate_ymd}.grb",
                        "actual_size": 3717759 if d < datetime.datetime(2017, 1, 1) else \
                            5373759 if d < datetime.datetime(2017, 11, 1) else \
                                53737590 if d < datetime.datetime(2022, 3, 25) else \
                                        54601590,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/20/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "135",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/kma_ref_cf_sfc_sfc{ymd}{hdate_ymd}.grb",
                        "actual_size": 33202080 if d < datetime.datetime(2017, 1, 1) else \
                            41251680 if d < datetime.datetime(2017, 10, 25) else \
                                42965280 if d < datetime.datetime(2022, 3, 25) else \
                                    76403160 if d < datetime.datetime(2023, 8, 17) else \
                                        87497718,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "121/122/134/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/KMA_ref_{T.lower()}_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                        "actual_size": 109144080,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "121/122/165/166/228228",
                        "step": step_sfc61,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/KMA_ref_{T.lower()}_da_sfc{ymd}{hdate_ymd}.grb",
                        "actual_size": 11146140 if d < datetime.datetime(2017, 2, 1) else \
                            14575140 if d < datetime.datetime(2017, 11, 1) else \
                                19946520 if d < datetime.datetime(2020, 9, 1) else \
                                    29186100 if d < datetime.datetime(2022, 3, 25) else \
                                        29335140,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "31/34/167/168/235/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    }
                ])

                toplevel = f"{self.S2S_toplevel}/KMA/REF_new/PF/{d.year}"
                self.all_models['KMA_REF_PF'].extend([
                    {
                        "target": f"{toplevel}/kma_ref_pf_pl_zuvt{ymd}{hdate_ymd}.grb",
                        "actual_size": 302067120 if d < datetime.datetime(2017, 1, 1) else \
                            436755120 if d < datetime.datetime(2022, 3, 25) else \
                                443782320 if d < datetime.datetime(2023, 8, 17) else \
                                    1331346960,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "130/131/132/156",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/kma_ref_cf_pl_q{ymd}{hdate_ymd}.grb",
                        "actual_size": 76432146 if d < datetime.datetime(2022, 3, 25) else \
                            77661906 if d < datetime.datetime(2023, 8, 17) else \
                                332836740 if d < datetime.datetime(2025, 9, 1) else \
                                    299553066,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/20/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "133",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/kma_ref_cf_pl_w{ymd}{hdate_ymd}.grb",
                        "actual_size": 7435518 if d < datetime.datetime(2017, 1, 1) else \
                            10747518 if d < datetime.datetime(2017, 11, 1) else \
                                107475180 if d < datetime.datetime(2022, 3, 25) else \
                                        109203180 if d < datetime.datetime(2023, 8, 17) else \
                                            327609540,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/20/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "135",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/kma_ref_cf_sfc_sfc{ymd}{hdate_ymd}.grb",
                        "actual_size": 66404160 if d < datetime.datetime(2017, 1, 1) else \
                            82503360 if d < datetime.datetime(2017, 10, 25) else \
                                85930560 if d < datetime.datetime(2020, 9, 1) else \
                                    150387120 if d < datetime.datetime(2022, 3, 25) else \
                                        152806320 if d < datetime.datetime(2023, 9, 1) else \
                                            524986308,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "121/122/134/151/165/166/169/172/175/176/177/179/228002/228143/228144/228228",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/KMA_ref_{T.lower()}_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                        "actual_size": 654864480,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "121/122/165/166/228228",
                        "step": step_sfc61,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/KMA_ref_{T.lower()}_da_sfc{ymd}{hdate_ymd}.grb",
                        "actual_size": 22292280 if d < datetime.datetime(2017, 1, 1) else \
                            29150280 if d < datetime.datetime(2017, 11, 1) else \
                                39893040 if d < datetime.datetime(2020, 9, 1) else \
                                    58372200 if d < datetime.datetime(2022, 3, 25) else \
                                        58670280 if d < datetime.datetime(2023, 8, 17) else \
                                            176010840,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": "1/to/6",
                        "origin": "rksl",
                        "param": "31/34/167/168/235/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
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
        start = KMA_REF_Model.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = KMA_REF_Model(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f'Total tasks are: {len(tasks)}')
