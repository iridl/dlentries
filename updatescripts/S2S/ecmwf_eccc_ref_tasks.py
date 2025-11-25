from ECMWF_REFModelTaskClass import ECMWF_REFModelTaskBase
import datetime

class ECCC_REF_Model(ECMWF_REFModelTaskBase):
    """
    Model used to download the ECCC hindcast models from the ECMWFDataServer()
    https://apps.ecmwf.int/datasets/data/s2s-reforecasts-instantaneous-accum-cwao/levtype=sfc/type=cf/
    Realtime dates are available on Mondays and Thursdays, but aren't accessible
    for 2 days (to be safe) after.  So this cron job should be run on Wednesdays and
    Saturdays, with a 2 day delay.
    """

    def __init__(self, start=None, delay=2, version_inc=0):
        """
        :param start: datetime day to get data (today-DefaultDelay if None)
        """
        super().__init__(start, delay, version_inc)

        step = "0/to/936/by/24"
        step_da_sfc = "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936"
        number = "1/to/3"

        self.all_models["ECCC_REF_PF"] = []
        self.all_models["ECCC_REF_CF"] = []

        y_m_d = f"{self.start.year}-{self.start.month:02d}-{self.start.day:02d}"
        ymd = f"{self.start.year}{self.start.month:02d}{self.start.day:02d}"

        forecast_yr = f"{self.start.year}"

        # Hindcast Years currently go from 2001 to 2020.  I don't know if that's going to
        # change in 2026, so for now this is hardcoded
        for year in range(2001, 2021):
            hdate_y_m_d = f"{year}-{self.start.month:02d}-{self.start.day:02d}"
            hdate_ymd = f"{year}{self.start.month:02d}{self.start.day:02d}"

            toplevel = f"{self.S2S_toplevel}/ECCC/REF_GEPS8/CF"
            modeltype = f"ECCC_REF_CF"
            self.all_models[modeltype].extend([
                {
                    "target": f"{toplevel}/eccc_ref_cf_pl_zuvt{ymd}{hdate_ymd}.grb",
                    "min_size": 90899640,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "130/131/132/156",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect" : "any",
                }, #1
                {
                    "target": f"{toplevel}/eccc_ref_cf_pl_q{ymd}{hdate_ymd}.grb",
                    "min_size": 15907437,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "133",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },  # 2
                {
                    "target": f"{toplevel}/eccc_ref_cf_pl_w{ymd}{hdate_ymd}.grb",
                    "min_size": 2272491,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "135",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },  # 3
                {
                    "target": f"{toplevel}/eccc_ref_cf_sfc_sfc{ymd}{hdate_ymd}.grb",
                    "min_size": 37288953,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "sfc",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/174008/228143/228144/228228",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{toplevel}/eccc_ref_cf_da_sfc{ymd}{hdate_ymd}.grb",
                    "min_size": 15530000,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "sfc",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "31/33/34/136/167/168/228032/228141/228164",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "target": f"{toplevel}/eccc_ref_cf_o2d{ymd}{hdate_ymd}.grb",
                    "min_size": 32978556,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "o2d",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },  # 7
                {
                    "target": f"{toplevel}/eccc_ref_cf_o2d1_{ymd}{hdate_ymd}.grb",
                    "min_size": 3664284,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "o2d",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "151163",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },  # depth of 20C isotherm
                {
                    "target": f"{toplevel}/eccc_ref_cf_o2d2_{ymd}{hdate_ymd}.grb",
                    "min_size": 3664284,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "o2d",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "151225",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                }  # 9 mixed layer thickness
            ])

            toplevel = f"{self.S2S_toplevel}/ECCC/REF_GEPS8/PF"
            modeltype = f"ECCC_REF_PF"
            self.all_models[modeltype].extend([
                {
                    "target": f"{toplevel}/eccc_ref_pf_pl_zuvt{ymd}{hdate_ymd}.grb",
                    "min_size": 272698920,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "130/131/132/156",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect" : "any",
                }, #1
                {
                    "target": f"{toplevel}/eccc_ref_pf_pl_q{ymd}{hdate_ymd}.grb",
                    "min_size": 47722311,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "133",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },  # 2
                {
                    "target": f"{toplevel}/eccc_ref_pf_pl_w{ymd}{hdate_ymd}.grb",
                    "min_size": 6817473,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "135",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },  # 3
                {
                    "target": f"{toplevel}/eccc_ref_pf_sfc_sfc{ymd}{hdate_ymd}.grb",
                    "min_size": 111866859,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "sfc",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/174008/228143/228144/228228",
                    "step": step,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{toplevel}/eccc_ref_pf_da_sfc{ymd}{hdate_ymd}.grb",
                    "min_size": 46580000,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "sfc",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "31/33/34/136/167/168/228032/228141/228164",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "target": f"{toplevel}/eccc_ref_pf_o2d{ymd}{hdate_ymd}.grb",
                    "min_size": 98935668,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "o2d",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },  # 7
                {
                    "target": f"{toplevel}/eccc_ref_pf_o2d1_{ymd}{hdate_ymd}.grb",
                    "min_size": 10992852,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "o2d",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "151163",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },  # depth of 20C isotherm
                {
                    "target": f"{toplevel}/eccc_ref_pf_o2d2_{ymd}{hdate_ymd}.grb",
                    "min_size": 10992852,
                    "class": "s2",
                    "dataset": "s2s",
                    "date": y_m_d,
                    "expver": "prod",
                    "hdate": hdate_y_m_d,
                    "levtype": "o2d",
                    "model": "glob",
                    "number": number,
                    "origin": "cwao",
                    "param": "151225",
                    "step": step_da_sfc,
                    "stream": "enfh",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                }  # mixed layer thickness
            ])
