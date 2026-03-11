from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime

class UKMO_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the egrr hindcast models from the ECMWFDataServer()
    https://apps.ecmwf.int/datasets/data/s2s-reforecasts-instantaneous-accum-egrr/levtype=sfc/type=cf/
    Realtime dates are available every day, but we only run once a week.
    """
    hindcast_start_year = 1993
    hindcast_end_year = 2016
    model_version_offset = 62
    weekdays = ["1", "9", "17", "25"]

    def __init__(self, start=None, end=None, weekdays=None, goback=None, model_version_offset=None):
        if weekdays is None:
            weekdays = UKMO_REF_Model.weekdays
        if model_version_offset is None:
            model_version_offset = UKMO_REF_Model.model_version_offset

        super().__init__(start, end, weekdays, goback, model_version_offset)

        step = "0/to/1440/by/24"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440"
        number = "1/to/6"

        self.all_models["UKMO_REF_PF"] = []
        self.all_models["UKMO_REF_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            for year in range(UKMO_REF_Model.hindcast_start_year, UKMO_REF_Model.hindcast_end_year + 1):
                hdate_y_m_d = f"{year}-{d.month:02d}-{d.day:02d}"
                hdate_ymd = f"{year}{d.month:02d}{d.day:02d}"

                for T in ["CF", "PF"]:
                    toplevel = f"{self.S2S_toplevel}/UKMO/REF/{T}"
                    modeltype = f"UKMO_REF_{T}"

                    self.all_models[modeltype].extend([
                        {
                            "target": f"{toplevel}/ukmo_ref_{T.lower()}_pl_zuvt{ymd}{hdate_ymd}.grb",
                            "min_size": 139400000 if T == "CF" else 183130000,
                            "class": "s2",
                            "dataset": "s2s",
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levelist": "10/50/100/200/300/500/700/850/925/1000",
                            "levtype": "pl",
                            "model": "glob",
                            "number": number,
                            "origin": "egrr",
                            "param": "130/131/132/156",
                            "step": step,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect" : "any",
                        },
                        {
                            "target": f"{toplevel}/ukmo_ref_{T.lower()}_pl_q{ymd}{hdate_ymd}.grb",
                            "min_size": 38216073 if T == "CF" else 229296438,
                            "class": "s2",
                            "dataset": "s2s",
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levelist": "200/300/500/700/850/925/1000",
                            "levtype": "pl",
                            "model": "glob",
                            "number": number,
                            "origin": "egrr",
                            "param": "133",
                            "step": step,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                        {
                            "target": f"{toplevel}/ukmo_ref_{T.lower()}_pl_w{ymd}{hdate_ymd}.grb",
                            "min_size": 5373759 if T == "CF" else 32242554,
                            "class": "s2",
                            "dataset": "s2s",
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levelist": "500",
                            "levtype": "pl",
                            "model": "glob",
                            "number": number,
                            "origin": "egrr",
                            "param": "135",
                            "step": step,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                        {
                            "target": f"{toplevel}/ukmo_ref_{T.lower()}_sfc_sfc{ymd}{hdate_ymd}.grb",
                            "min_size": 75372558 if T == "CF" else 419478714,
                            "class": "s2",
                            "dataset": "s2s",
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levtype": "sfc",
                            "model": "glob",
                            "number": number,
                            "origin": "egrr",
                            "param": "121/122/134/165/166/169/172/175/176/177/179/228143/228144/228228",
                            "step": step,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                        {
                            "target": f"{toplevel}/ukmo_ref_{T.lower()}_da_sfc{ymd}{hdate_ymd}.grb",
                            "min_size": 28905840 if T == "CF" else 173435040,
                            "class": "s2",
                            "dataset": "s2s",
                            "date": y_m_d,
                            "expver": "prod",
                            "hdate": hdate_y_m_d,
                            "levtype": "sfc",
                            "model": "glob",
                            "number": number,
                            "origin": "egrr",
                            "param": "31/34/167/168/235/228164",
                            "step": step_da_sfc,
                            "stream": "enfh",
                            "time": "00:00:00",
                            "type": f"{T.lower()}",
                            "expect": "any",
                        },
                    ])

if __name__ == '__main__':
    model = UKMO_REF_Model(start=None)
    print(model.dates)
    for key in model.all_models.keys():
        for task in model.all_models[key]:
            print(task['target'])
