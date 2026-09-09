from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime


class IAPCAS_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the IAPCAS hindcast models from the ECMWFDataServer()
    https://confluence.ecmwf.int/spaces/S2S/pages/234233252/IAP-CAS+Model
    https://ecds.ecmwf.int/datasets/s2s-reforecasts?tab=download
    """
    first_date = datetime.datetime(2020, 1, 1)

    model_version_offset = 0  # days
    weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    origin = "anso"
    
    def __init__(self, start=None, end=None, weekdays=None, goback=None, model_version_offset=None):
        if weekdays is None:
            weekdays = IAPCAS_REF_Model.weekdays
        if model_version_offset is None:
            model_version_offset = IAPCAS_REF_Model.model_version_offset

        super().__init__(start, end, weekdays, goback, model_version_offset)

        normal_step = "24/to/1560/by/24"
        step_sfc6 = "6/to/1560/by/6"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440/1440-1464/1464-1488/1488-1512/1512-1536/1536-1560"
        number = "1/to/6"

        self.all_models["IAPCAS_REF_PF"] = []
        self.all_models["IAPCAS_REF_CF"] = []

        for d in self.dates:
            hindcast_start_year = 1999
            hindcast_end_year = 2018

            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            for year in range(hindcast_start_year, hindcast_end_year + 1):
                hdate_y_m_d = f"{year}-{d.month:02d}-{d.day:02d}"
                hdate_ymd = f"{year}{d.month:02d}{d.day:02d}"

                toplevel = f"{self.S2S_toplevel}/IAP-CAS/REF/CF"
                self.all_models['IAPCAS_REF_CF'].extend([
                    {
                        "target": f"{toplevel}/IAPCAS_REF_cf_pl_zuvt{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "130/131/132/156",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_cf_pl_q{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "133",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_cf_pl_w{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "500",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "135",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_cf_sfc_sfc{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "121/122/134/165/166/169/172/175/176/177/179/228002/228144/228228",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_cf_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                        "actual_size": 109144080,
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "121/122/165/166/228228",
                        "step": step_sfc6,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_cf_da_sfc{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "31/34/167/168/235/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "cf",
                        "expect": "any",
                    }
                ])

                toplevel = f"{self.S2S_toplevel}/IAP-CAS/REF/PF"
                self.all_models['IAPCAS_REF_PF'].extend([
                    {
                        "target": f"{toplevel}/IAPCAS_REF_pf_pl_zuvt{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "10/50/100/200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "130/131/132/156",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_pf_pl_q{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "133",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_pf_pl_w{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "500",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "135",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_pf_sfc_sfc{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "121/122/134/165/166/169/175/176/177/179/228144/228228",
                        "step": normal_step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_pf_sfc_sfc6_{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "121/122/165/166/228228",
                        "step": step_sfc6,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    },
                    {
                        "target": f"{toplevel}/IAPCAS_REF_pf_da_sfc{ymd}{hdate_ymd}.grb",
                        "class": IAPCAS_REF_Model.s2s_class,
                        "dataset": IAPCAS_REF_Model.dataset,
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": IAPCAS_REF_Model.origin,
                        "param": "31/167/168/235/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": "pf",
                        "expect": "any",
                    }
                ])

if __name__ == '__main__':
    import argparse

    args = parser.parse_args()
    start = IAPCAS_REF_Model.first_date
    end = IAPCAS_REF_Model.first_date

    model = IAPCAS_REF_Model(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f'Total tasks are: {len(tasks)}')
