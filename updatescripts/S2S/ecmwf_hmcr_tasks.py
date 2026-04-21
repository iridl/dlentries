from ECMWFModelTaskClass import ECMWFModelTaskBase
import datetime

class HMCRModel(ECMWFModelTaskBase):
    """
    Model used to download the HMCR model data from the ECMWFDataServer()
        https://confluence.ecmwf.int/display/S2S/HMCR+Model
        https://apps.ecmwf.int/datasets/data/s2s-realtime-instantaneous-accum-rums/
    """
    first_date = datetime.datetime(2015, 1, 7)

    # Data Access Delay, how many days back is the first forecast we can get.
    data_access_delay = 2

    # weekdays: days of week data is available
    weekdays = ["Thu"]
    origin = "rums"

    def __init__(self, start=None, end=None, weekdays=None, goback=None):
        if weekdays is None:
            weekdays = HMCRModel.weekdays

        super().__init__(start, end, weekdays, goback, HMCRModel.data_access_delay)

        pf_toplevel = f"{self.S2S_toplevel}/HMCR/REL/PF"
        cf_toplevel = f"{self.S2S_toplevel}/HMCR/REL/CF"

        self.all_models['HMCR_REL_1p5_CF'] = []
        self.all_models['HMCR_REL_1p5_PF'] = []

        self.all_models['HMCR_REL_CF'] = []
        self.all_models['HMCR_REL_PF'] = []

        for d in self.dates:
            y_m_d = f"{d.year}-{d.month:02d}-{d.day:02d}"
            ymd = f"{d.year}{d.month:02d}{d.day:02d}"

            pf_1p5_toplevel = f"{self.S2S_toplevel}/HMCR/REL_new/PF/{d.year}"
            cf_1p5_toplevel = f"{self.S2S_toplevel}/HMCR/REL_new/CF/{d.year}"

            self.all_models['HMCR_REL_1p5_CF'].extend([
            {
                "actual_size": 130040784 if d < datetime.datetime(2022,9,15) else 109532560,
                "target": f"{cf_1p5_toplevel}/hmcr_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "130/131/132/156",
                "step": "0/to/1140/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },
            {
                "actual_size": 25285708 if d < datetime.datetime(2022,9,15) else 19168198,
                "target": f"{cf_1p5_toplevel}/hmcr_rel_cf_pl_q{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "133",
                "step": "0/to/1140/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },
            {
                "actual_size": 71510260 if d < datetime.datetime(2015,9,16) else \
                    71452180 if d < datetime.datetime(2022,9,15) else 53968540,
                "target": f"{cf_1p5_toplevel}/hmcr_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/228002/228143/228144/228228",
                "step": "0/to/1140/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },
            {
                "actual_size": 21449248,
                "target": f"{cf_1p5_toplevel}/hmcr_rel_cf_sfc_sfc6_{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "121/122",
                "step": "6/to/1140/by/6",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },
            {
                "actual_size": 32281770,
                "target": f"{cf_1p5_toplevel}/hmcr_rel_cf_sfc_sfc62_{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "165/166/228228",
                "step": "0/to/1140/by/6",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            },
            {
                "min_size": 22070000,
                "target": f"{cf_1p5_toplevel}/hmcr_rel_cf_da_sfc{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "31/34/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "cf",
                "expect": "any",
            }])

            self.all_models['HMCR_REL_1p5_PF'].extend([
            {
                "actual_size": 2470774896 if d < datetime.datetime(2022,9,15) else 4381302400,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "130/131/132/156",
                "step": "0/to/1464/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 617693724 if d < datetime.datetime(2022,9,15) else 1095325600,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_pl_z{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "156",
                "step": "0/to/1464/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 617693724 if d < datetime.datetime(2022,9,15) else 1095325600,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_pl_t{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "130",
                "step": "0/to/1464/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 617693724 if d < datetime.datetime(2022,9,15) else 1095325600,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_pl_u{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "131",
                "step": "0/to/1464/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 617693724 if d < datetime.datetime(2022,9,15) else 1095325600,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_pl_v{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "10/50/100/200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "132",
                "step": "0/to/1464/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 480428452 if d < datetime.datetime(2022,9,15) else 766727920,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_pl_q{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levelist": "200/300/500/700/850/925/1000",
                "levtype": "pl",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "133",
                "step": "0/to/1104/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 1221429668 if d < datetime.datetime(2015,9,16) else \
                    1220326148 if d < datetime.datetime(2022,9,15) else 1939676480,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "121/122/134/146/147/151/165/166/169/175/176/177/179/180/181/228143/228144/228228",
                "step": "0/to/1104/by/24",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 857969920,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_sfc_sfc6_{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "121/122",
                "step": "6/to/1140/by/6",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "actual_size": 1291270800,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_sfc_sfc62_{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "165/166/228228",
                "step": "0/to/1140/by/6",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            },
            {
                "min_size": 555040000,
                "target": f"{pf_1p5_toplevel}/hmcr_rel_pf_da_sfc{ymd}{ymd}.grb",
                "class": HMCRModel.s2s_class,
                "dataset": HMCRModel.dataset,
                "date": y_m_d,
                "expver": "prod",
                "levtype": "sfc",
                "model": "glob",
                "number": "1/to/40",
                "origin":  HMCRModel.origin,
                "param": "31/34/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104",
                "stream": "enfo",
                # "grid": "2.5/2.5",
                # "area": "-88.75/0/88.75/360",
                "time": "00:00:00",
                "type": "pf",
                "expect": "any",
            }])

            ### 2.5x2.5 download scripts
            self.all_models['HMCR_REL_CF'].extend([
                {
                    "actual_size": 47331792 if d < datetime.datetime(2018, 11, 1) else \
                        46688976 if d < datetime.datetime(2022, 9, 15) else 35393256,
                    "target": f"{cf_toplevel}/hmcr_rel_cf_pl_zuvt{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "130/131/132/156",
                    "step": "0/to/1464/by/24",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 9203404 if d < datetime.datetime(2018, 11, 1) else \
                        9078412 if d < datetime.datetime(2022, 9, 15) else \
                            6882022,
                    "target": f"{cf_toplevel}/hmcr_rel_cf_pl_q{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "133",
                    "step": "0/to/1464/by/24",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 23413004 if d < datetime.datetime(2015, 9, 16) else \
                        23391980 if d < datetime.datetime(2016, 12, 14) else \
                            26021524 if d < datetime.datetime(2018, 11, 11) else \
                                25668436 if d < datetime.datetime(2022, 9, 15) else \
                                    19387996,
                    "target": f"{cf_toplevel}/hmcr_rel_cf_sfc_sfc{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/228002/228143/228144/228228",
                    "step": "0/to/1464/by/24",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                },
                {
                    "min_size": 7947000,
                    "target": f"{cf_toplevel}/hmcr_rel_cf_da_sfc{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "31/34/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440/1440-1464",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
                    "time": "00:00:00",
                    "type": "cf",
                    "expect": "any",
                }
            ])

            self.all_models['HMCR_REL_PF'].extend([
                {
                    "min_size": 2470774896 if d < datetime.datetime(2018, 11, 1) else \
                        887090544 if d < datetime.datetime(2022, 9, 15) else \
                            707865120,
                    "target": f"{pf_toplevel}/hmcr_rel_pf_pl_zuvt{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "50/100/200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "130/131/132/156",
                    "step": "0/to/1464/by/24",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 174864676 if d < datetime.datetime(2018, 11, 1) else \
                        172489828 if d < datetime.datetime(2022, 9, 15) else \
                            137640440,
                    "target": f"{pf_toplevel}/hmcr_rel_pf_pl_q{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levelist": "200/300/500/700/850/925/1000",
                    "levtype": "pl",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "133",
                    "step": "0/to/1464/by/24",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 444847076 if d < datetime.datetime(2015, 9, 16) else \
                        444447620 if d < datetime.datetime(2018, 11, 1) else \
                            438417476 if d < datetime.datetime(2022, 9, 15) else \
                                348434080,
                    "target": f"{pf_toplevel}/hmcr_rel_pf_sfc_sfc{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "121/122/134/146/147/151/165/166/169/172/175/176/177/179/180/181/228002/228143/228144/228228",
                    "step": "0/to/1464/by/24",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
                    "time": "00:00:00",
                    "type": "pf",
                    "expect": "any",
                },
                {
                    "min_size": 158950000,
                    "target": f"{pf_toplevel}/hmcr_rel_pf_da_sfc{ymd}{ymd}.grb",
                    "class": HMCRModel.s2s_class,
                    "dataset": HMCRModel.dataset,
                    "date": y_m_d,
                    "expver": "prod",
                    "levtype": "sfc",
                    "model": "glob",
                    "number": "1/to/20",
                    "origin":  HMCRModel.origin,
                    "param": "31/34/167/168/235/228032/228086/228087/228095/228096/228141/228164",
                    "step": "0-24/24-48/48-72/72-96/96-120/120-144/144-168/168-192/192-216/216-240/240-264/264-288/288-312/312-336/336-360/360-384/384-408/408-432/432-456/456-480/480-504/504-528/528-552/552-576/576-600/600-624/624-648/648-672/672-696/696-720/720-744/744-768/768-792/792-816/816-840/840-864/864-888/888-912/912-936/936-960/960-984/984-1008/1008-1032/1032-1056/1056-1080/1080-1104/1104-1128/1128-1152/1152-1176/1176-1200/1200-1224/1224-1248/1248-1272/1272-1296/1296-1320/1320-1344/1344-1368/1368-1392/1392-1416/1416-1440/1440-1464",
                    "stream": "enfo",
                    "grid": "2.5/2.5",
                    "area": "-88.75/0/88.75/360",
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
        start = HMCRModel.first_date
    else:
        start = datetime.datetime.strptime(args.start, "%Y-%m-%d")

    if args.end is not None:
        if args.end == "now":
            end = datetime.datetime.now()
        else:
            end = datetime.datetime.strptime(args.start, "%Y-%m-%d")
    else:
        end = datetime.datetime.now()

    model = HMCRModel(start, end)
    tasks = model.get_tasks(prune=True, dryrun=True)
    for t in tasks:
        print(t['target'])
    print(f"Total tasks: {len(tasks)}")