from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime

class HMCR_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the HMCR hindcast models from the ECMWFDataServer()
    https://apps.ecmwf.int/datasets/data/s2s-reforecasts-instantaneous-accum-rums/levtype=sfc/type=cf/
    Realtime dates are available once a week on Thursdays, so this cron job should be run on Fridays, with a 1 day delay.
    """

    def __init__(self, start=None, delay=1, version_inc=14):
        """
        :param start: datetime day to get data (today-DefaultDelay if None)
        """
        super().__init__(start, delay, version_inc)

        step = "0/to/1464/by/24"
        step_sfc61 = "6/to/1464/by/6"
        step_sfc62 = "0/to/1464/by/6"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440/1440-1464"
        number = "1/to/10"

        self.all_models["HMCR_REF_PF"] = []
        self.all_models["HMCR_REF_CF"] = []

        y_m_d = f"{self.start.year}-{self.start.month:02d}-{self.start.day:02d}"
        ymd = f"{self.start.year}{self.start.month:02d}{self.start.day:02d}"

        forecast_yr = f"{self.start.year}"

        # Hindcast Years currently go from 1991 to 2020.  I don't know if that's going to
        # change in 2026, so for now this is hardcoded
        for year in range(1991, 2021):
            hdate_y_m_d = f"{year}-{self.start.month:02d}-{self.start.day:02d}"
            hdate_ymd = f"{year}{self.start.month:02d}{self.start.day:02d}"

            for T in ["CF", "PF"]:
                toplevel = f"{self.S2S_toplevel}/HMCR/REF_new/{T}/{self.start.year}"
                modeltype = f"HMCR_REF_{T}"

                self.all_models[modeltype].extend([
                    {
                        "target": f"{toplevel}/hmcr_ref_{T.lower()}_pl_zuvt{ymd}{hdate_ymd}.grb",
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
                        "origin": "rums",
                        "param": "130/131/132/156",
                        "step": step,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{T.lower()}",
                        "expect" : "any",
                    },
                    {
                        "target": f"{toplevel}/hmcr_ref_{T.lower()}_pl_q{ymd}{hdate_ymd}.grb",
                        "min_size": 19170501,
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levelist": "200/300/500/700/850/925/1000",
                        "levtype": "pl",
                        "model": "glob",
                        "number": number,
                        "origin": "rums",
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
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "rums",
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
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "rums",
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
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "sfc",
                        "model": "glob",
                        "number": number,
                        "origin": "rums",
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
                        "class": "s2",
                        "dataset": "s2s",
                        "date": y_m_d,
                        "expver": "prod",
                        "hdate": hdate_y_m_d,
                        "levtype": "o2d",
                        "model": "glob",
                        "number": number,
                        "origin": "rums",
                        "param": "31/34/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                        "step": step_da_sfc,
                        "stream": "enfh",
                        "time": "00:00:00",
                        "type": f"{T.lower()}",
                        "expect": "any",
                    }
                ])
