from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

# Todo
# There are a number of variables that were added after certain dates.  Do we want to go back
# and fix them all??
# 2016/ecmf_rel_pf_pl_w2016100320161003.grb
# 2020/ecmf_rel_pf_o2d1_2020010220200102.grb
# 2020/ecmf_rel_pf_o2d2_2020010220200102.grb
# 2020/ecmf_rel_pf_o2d2020010220200102.grb
# 2020/ecmf_rel_pf_sfc6_2020122120201221.grb
# 2020/ecmf_rel_pf_sfc62_2020111220201112.grb
#


class ECMF4147Model(ECMWFModelTaskBase):
    """
    Model used to download the older ECMWF models from the ECMWFDataServer()
    """
    # This is the old data, and this is the first and last days of the data.
    first_date = datetime.datetime(2015, 5, 14)
    last_date = datetime.datetime(2023, 6, 26)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Mon", "Thu"]

    origin = "ecmf"

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = ECMF4147Model.weekdays

        if start is not None and start > ECMF4147Model.last_date:
            raise ValueError("Start date is beyond the final date of the data.")

        super().__init__(start, end, weekdays, goback)

        self.all_models["ECMF_REL_PF"] = []
        self.all_models["ECMF_REL_CF"] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            pf_toplevel = f"{self.S2S_toplevel}/ECMF/REL/PF/{d.year}"
            cf_toplevel = f"{self.S2S_toplevel}/ECMF/REL/CF/{d.year}"

            self.all_models["ECMF_REL_PF"].extend([
                {
                    "min_size": 5038497760,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "130/131/132/156",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 1259624440,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_z{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "156",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 1259624440,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_t{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "130",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 1259624440,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_u{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "131",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 1259624440,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_v{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "132",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 881737108,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_q{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "133",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 1259624440,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pl_w{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "135",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 2330721744,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "43/121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/174008/228143/228144/228205/228228",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 470121748,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_sfc_sfc3_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "180/181/174008/228205/228228",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": 11750
                },
                {
                    "min_size": 1860599996,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_sfc_sfc2_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/228143/228144",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": 35150
                },
                {
                    "min_size": 1377818400,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 125962444,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_pt_pv{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "320",
                    "levtype": "pt",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "60",
                    "step": "0/to/1104/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "min_size": 1745233284,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_o2d{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "grid": "1.0/1.0",
                    "expect": "any"
                },
                {
                    "min_size": 199222228,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_o2d1_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "151163",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "grid": "1.0/1.0",
                    "expect": "any"
                },
                {
                    "min_size": 199222228,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_o2d2_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "151225",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "grid": "1.0/1.0",
                    "expect": "any"
                },
                {
                    "min_size": 1484961420,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_sfc62_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "165/166/228228",
                    "step": "0/to/1104/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
                {
                    "actual_size": 1072462400,
                    "target": f"{pf_toplevel}/ecmf_rel_pf_sfc6_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "121/122",
                    "step": "6/to/1104/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any"
                },
            ])

            self.all_models["ECMF_REL_CF"].extend([
                {
                    "min_size": 100769955,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "130/131/132/156",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 17634742,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_pl_q{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "133",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 25192488,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_pl_w{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "10/50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "135",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 50151731,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "43/121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/174008/228143/228144/228205/228228",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": 1032
                },
                {
                    "min_size": 9402434,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_sfc_sfc3_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": ECMF4147Model.origin,
                    "param": "180/181/174008/228205/228228",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 9972203,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_sfc_sfc21_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": ECMF4147Model.origin,
                    "param": "134/146/147/151",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 14853514,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_sfc_sfc22_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": ECMF4147Model.origin,
                    "param": "169/172/175/176/177/179",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 15923578,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_sfc_sfc23_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "origin": ECMF4147Model.origin,
                    "param": "43/121/122/165/166/228143/228144",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "actual_size": 21449248 if d < datetime.datetime(2022, 1, 1) else (43006188 if d < datetime.datetime(2022, 11, 17) else 21449248),
                    "target": f"{cf_toplevel}/ecmf_rel_cf_sfc_sfc6_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "121/122",
                    "step": "6/to/1104/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 29699228,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_sfc_sfc62_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "165/166/228228",
                    "step": "0/to/1104/by/6",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 27555788,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "31/33/34/59/136/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 2519248,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_pt_pv{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "320",
                    "levtype": "pt",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "60",
                    "step": "0/to/1104/by/24",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any"
                },
                {
                    "min_size": 34906932,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_o2d{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "151126/151131/151132/151145/151163/151175/151219/151225/174098",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "grid": "1.0/1.0",
                    "expect": "any"
                },
                {   # depth of 20C isotherm
                    "min_size": 3987432,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_o2d1_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "151163",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "grid": "1.0/1.0",
                    "expect": "any"
                },
                {   # 9 mixed layer thickness
                    "min_size": 3987432,
                    "target": f"{cf_toplevel}/ecmf_rel_cf_o2d2_{ymd}{ymd}.grb",
                    "class": ECMF4147Model.s2s_class,
                    "dataset": ECMF4147Model.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "o2d",
                    "model": "glob",
                    "number": "1/to/50",
                    "origin": ECMF4147Model.origin,
                    "param": "151225",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                    "stream": "enfo",
                    "time": "00:00:00",
                    "type": "cf",
                    "grid": "1.0/1.0",
                    "expect": "any"
                }
            ])

if __name__ == '__main__':
    import argparse
    start = end = None

    parser = argparse.ArgumentParser(description="Check Data from ECMF4147 Model.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Today, b yut default.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD (or \"now\".  Will only run 1 day if not defined")

    args = parser.parse_args()
    if args.start is None:
        start = ECMF4147Model.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = ECMF4147Model(start=start, end=end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")
